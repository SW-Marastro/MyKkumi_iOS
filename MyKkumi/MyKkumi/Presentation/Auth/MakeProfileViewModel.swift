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
    var completeButtonTap : PublishSubject<Void> { get }
    var libraryTap : PublishSubject<Void> { get }
    var cameraTap : PublishSubject<Void> { get }
}

protocol MakeProfileViewModelOutput {
    var sholudPushSelectAlert : Driver<Void> { get }
    var sholudPushImagePicker : Driver<Bool> { get }
    var sholudPushCamera : Driver<Bool> { get }
}

protocol MakeProfileViewModelProtocol : MakeProfileViewModelInput, MakeProfileViewModelOutput {
    var imageData : BehaviorRelay<UIImage?> { get }
}

class MakeProfileViewModel : MakeProfileViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    init() {
        self.profileImageTap = PublishSubject<Void>()
        self.infoIconPush = PublishSubject<Void>()
        self.completeButtonTap = PublishSubject<Void>()
        self.libraryTap = PublishSubject<Void>()
        self.cameraTap = PublishSubject<Void>()
        self.imageData = BehaviorRelay<UIImage?>(value: nil)
        
        self.sholudPushSelectAlert = self.profileImageTap
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
    }
    
    public var profileImageTap: PublishSubject<Void>
    public var infoIconPush: PublishSubject<Void>
    public var completeButtonTap: PublishSubject<Void>
    public var libraryTap: PublishSubject<Void>
    public var cameraTap: PublishSubject<Void>
    
    public var sholudPushSelectAlert: Driver<Void>
    public var sholudPushImagePicker: Driver<Bool>
    public var sholudPushCamera: Driver<Bool>
    
    public var imageData: BehaviorRelay<UIImage?>
}
