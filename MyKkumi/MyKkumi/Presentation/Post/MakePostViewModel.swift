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
}

public protocol MakePostViewModelOutput {
    var sholudPushSelectAlert : Driver<Void> { get }
    var sholudPushImagePicker : Driver<Bool> { get }
    var sholudPushCamera : Driver<Bool> { get }
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
        
        self.selectedImageRelay
            .subscribe(onNext: {[weak self] images in
                guard let self = self else {return}
                var tmpViewModel : [SelectedImageViewModelProtocol] = []
                images.forEach { image in
                    tmpViewModel.append(SelectedImageViewModel())
                }
                self.selectedImageViewModels.accept(tmpViewModel)
            })
            .disposed(by: disposeBag)
    }
    
    public var sholudPushSelectAlert: Driver<Void>
    public var sholudPushCamera: Driver<Bool>
    public var sholudPushImagePicker: Driver<Bool>
    
    public var cameraTap: PublishSubject<Void>
    public var libraryTap: PublishSubject<Void>
    
    public var selectedImageRelay: BehaviorRelay<[UIImage]>
    public var selectedImageViewModels: BehaviorRelay<[any SelectedImageViewModelProtocol]>
    public var deliverAddImageViewModel: BehaviorRelay<any AddImageViewModelProtocol>
}
