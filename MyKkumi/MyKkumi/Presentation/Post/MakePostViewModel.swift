//
//  MakePostViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/31/24.
//

import Foundation
import RxCocoa
import RxSwift
import Photos
import AVFoundation

public protocol MakePostViewModelInput {
    var cameraTap : PublishSubject<Void> { get }
    var libraryTap : PublishSubject<Void> { get }
    var deleteCellImageInput : PublishSubject<Int> { get }
}

public protocol MakePostViewModelOutput {
    var sholudPushSelectAlert : Driver<Void> { get }
    var sholudPushImagePicker : Driver<Bool> { get }
    var sholudPushCamera : Driver<Bool> { get }
    var deleteCellImage : Driver<Bool> { get }
}

public protocol MakePostViewModelProtocol : MakePostViewModelOutput,  MakePostViewModelInput{
    var selectedImageRelay : BehaviorRelay<[UIImage]>{ get }
    var selectedImageViewModels : BehaviorRelay<[SelectedImageViewModelProtocol]> { get }
    var deliverAddImageViewModel : BehaviorRelay<AddImageViewModelProtocol>{ get }
}

public class MakePostViewModel : MakePostViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let addImageViewModel = AddImageViewModel()
    
    public init() {
        self.selectedImageRelay = BehaviorRelay<[UIImage]>(value: [])
        self.selectedImageViewModels = BehaviorRelay<[SelectedImageViewModelProtocol]>(value: [])
        self.deliverAddImageViewModel = BehaviorRelay<AddImageViewModelProtocol>(value: addImageViewModel)
        self.cameraTap = PublishSubject<Void>()
        self.libraryTap = PublishSubject<Void>()
        self.deleteCellImageInput = PublishSubject<Int>()
        
        self.sholudPushSelectAlert = self.addImageViewModel.addButtonTap
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
        
        self.deleteCellImage = self.selectedImageRelay
            .map{ _ in true }
            .asDriver(onErrorDriveWith: .empty())
        
        //이부분에서 그냥 deleteCellimage에 따라서 쪼개고 deletecelliamge는 그와 상관 없이 이벤트 방출하도록 만들면 해결 가능 할드
        self.deleteCellImageInput
            .subscribe(onNext : {[weak self] index in
                guard let self = self else { return }
                var images = self.selectedImageRelay.value
                guard index >= 0  && index < images.count else {return }

                images.remove(at: index)
                self.selectedImageRelay.accept(images)

                var tmpViewModels = self.selectedImageViewModels.value
                tmpViewModels.remove(at: index)
                self.selectedImageViewModels.accept(tmpViewModels)
            })
            .disposed(by: disposeBag)
        
        self.selectedImageRelay
            .subscribe(onNext: {[weak self] images in
                guard let self = self else {return}
                var tmpViewModel : [SelectedImageViewModelProtocol] = []
                images.enumerated().forEach { index, image in
                    let selectedImageViewModel = SelectedImageViewModel(index)
                    tmpViewModel.append(selectedImageViewModel)
                    selectedImageViewModel.deleteButtonTap
                        .map{ index }
                        .bind(to : self.deleteCellImageInput)
                        .disposed(by: self.disposeBag)
                }
                self.selectedImageViewModels.accept(tmpViewModel)
            })
            .disposed(by: disposeBag)

    }
    
    public var sholudPushSelectAlert: Driver<Void>
    public var sholudPushCamera: Driver<Bool>
    public var sholudPushImagePicker: Driver<Bool>
    public var deleteCellImage: Driver<Bool>
    
    public var cameraTap: PublishSubject<Void>
    public var libraryTap: PublishSubject<Void>
    public var deleteCellImageInput: PublishSubject<Int>
    
    public var selectedImageRelay: BehaviorRelay<[UIImage]>
    public var selectedImageViewModels: BehaviorRelay<[any SelectedImageViewModelProtocol]>
    public var deliverAddImageViewModel: BehaviorRelay<any AddImageViewModelProtocol>
}
