//
//  MakeProfileViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/15/24.
//

import Foundation
import RxSwift
import RxCocoa
import Photos
import AVFoundation

protocol MakeProfileViewModelInput {
    var profileImageTap : PublishSubject<Void> { get }
    var infoIconPush : PublishSubject<Void> { get }
    var completeButtonTap : PublishSubject<PatchUserVO?> { get }
    var libraryTap : PublishSubject<Void> { get }
    var cameraTap : PublishSubject<Void> { get }
    var nickNameInput : PublishSubject<String>{ get }
    var deleteButtonTap : PublishSubject<Void> { get }
}

protocol MakeProfileViewModelOutput {
    var sholudPushSelectAlert : Driver<Void> { get }
    var sholudPushImagePicker : Driver<Bool> { get }
    var sholudPushCamera : Driver<Bool> { get }
    var sholudPopView : Driver<UserVO> { get }
    var deleteTextField : Driver<Void> { get }
}

protocol MakeProfileViewModelProtocol : MakeProfileViewModelInput, MakeProfileViewModelOutput {
    var imageData : BehaviorRelay<UIImage?> { get }
    var nickName : BehaviorRelay<String?> { get }
    var categoryList : BehaviorRelay<[Int]?> { get }
    var imageUrl : BehaviorRelay<String?> { get }
}

class MakeProfileViewModel : MakeProfileViewModelProtocol {
    private let authUsecase : AuthUsecase
    private let makePostUsecase : MakePostUseCase
    private let disposeBag = DisposeBag()
    
    init(authUsecase : AuthUsecase = DependencyInjector.shared.resolve(AuthUsecase.self), makepostUseCase : MakePostUseCase = DependencyInjector.shared.resolve(MakePostUseCase.self),categoryList : [Int]? = nil) {
        self.authUsecase = authUsecase
        self.makePostUsecase = makepostUseCase
        
        self.profileImageTap = PublishSubject<Void>()
        self.infoIconPush = PublishSubject<Void>()
        self.completeButtonTap = PublishSubject<PatchUserVO?>()
        self.libraryTap = PublishSubject<Void>()
        self.cameraTap = PublishSubject<Void>()
        self.nickNameInput = PublishSubject<String>()
        self.deleteButtonTap = PublishSubject<Void>()
        
        self.imageData = BehaviorRelay<UIImage?>(value: nil)
        self.nickName = BehaviorRelay<String?>(value : nil)
        self.categoryList = BehaviorRelay<[Int]?>(value: categoryList)
        self.imageUrl = BehaviorRelay<String?>(value: nil)
        
        self.sholudPushSelectAlert = self.profileImageTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.deleteTextField = self.deleteButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        let libraryAuth = self.libraryTap
            .compactMap {_ -> Bool? in
                let status = PHPhotoLibrary.authorizationStatus()
                switch status {
                case .authorized :
                    return true
                case .denied, .restricted :
                    return false
                case .notDetermined :
                    var flag = false
                    PHPhotoLibrary.requestAuthorization { newStatus in
                        if newStatus == .authorized {
                            flag = true
                        } else {
                            flag = false
                        }
                    }
                    return flag
                case .limited :
                    return true
                @unknown default :
                    return false
                }
            }
        
        self.sholudPushImagePicker = libraryAuth
            .asDriver(onErrorDriveWith: .empty())
        
        let cameraAuth = self.cameraTap
            .compactMap{_ -> Bool? in
                let status = AVCaptureDevice.authorizationStatus(for: .video)
                switch status {
                case .authorized :
                    return true
                case .denied, .restricted :
                    return false
                case .notDetermined :
                    var flag = false
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            flag = true
                        } else {
                            flag = false
                        }
                    }
                    return flag
                @unknown default :
                    return false
                }
            }
        
        self.sholudPushCamera = cameraAuth
            .asDriver(onErrorDriveWith: .empty())
        
        let patchUserResult = self.completeButtonTap
            .flatMap{user in
                return authUsecase.patchUserData(user!)
            }
            .share()
        
        self.sholudPopView = patchUserResult
            .compactMap{ $0.successValue() }
            .asDriver(onErrorDriveWith: .empty())
        
        self.nickNameInput
            .subscribe(onNext: {[weak self] nickname in
                self?.nickName.accept(nickname)
            })
            .disposed(by: disposeBag)
        
        self.imageData
            .subscribe(onNext: {[weak self] image in
                guard let self = self else { return }
                guard let image = image else { return }

                self.authUsecase.getPresignedUrl()
                    .subscribe(onSuccess: { result in
                        if case let .success(url) = result {
                            let resizedImage = image.resized(toMaxSize: CGSize(width: 1024, height: 1024))
                            let imageToData = resizedImage.jpegData(compressionQuality: 1)!
                            makepostUseCase.putImage(url: url.presignedUrl, image: imageToData)
                                .subscribe(onSuccess: { _ in
                                    self.imageUrl.accept(url.cdnUrl)
                                })
                                .disposed(by: self.disposeBag)
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    public var profileImageTap: PublishSubject<Void>
    public var infoIconPush: PublishSubject<Void>
    public var completeButtonTap: PublishSubject<PatchUserVO?>
    public var libraryTap: PublishSubject<Void>
    public var cameraTap: PublishSubject<Void>
    public var nickNameInput: PublishSubject<String>
    public var deleteButtonTap: PublishSubject<Void>
    
    public var sholudPushSelectAlert: Driver<Void>
    public var sholudPushImagePicker: Driver<Bool>
    public var sholudPushCamera: Driver<Bool>
    public var sholudPopView: Driver<UserVO>
    public var deleteTextField: Driver<Void>
    
    public var imageData: BehaviorRelay<UIImage?>
    public var nickName: BehaviorRelay<String?>
    public var categoryList: BehaviorRelay<[Int]?>
    public var imageUrl: BehaviorRelay<String?>
}
