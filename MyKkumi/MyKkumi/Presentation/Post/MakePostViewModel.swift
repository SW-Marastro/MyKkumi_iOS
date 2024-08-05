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
    var deliverSelectedIndex : PublishSubject<Int> { get }
}

public protocol MakePostViewModelOutput {
    var sholudPushSelectAlert : Driver<Void> { get }
    var sholudPushImagePicker : Driver<Bool> { get }
    var sholudPushCamera : Driver<Bool> { get }
    var deleteCellImage : Driver<Int> { get }
    var changeSelectedImage : Driver<Void> { get }
}

public protocol MakePostViewModelProtocol : MakePostViewModelOutput,  MakePostViewModelInput{
    var selectedImageRelay : BehaviorRelay<[UIImage]>{ get }
    var selectedImageViewModels : BehaviorRelay<[SelectedImageViewModelProtocol]> { get }
    var deliverAddImageViewModel : BehaviorRelay<AddImageViewModelProtocol>{ get }
    var selectedImageIndex : Int { get }
}

public class MakePostViewModel : MakePostViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let addImageViewModel = AddImageViewModel()
    public var selectedImageIndex: Int = -1
    
    public init() {
        self.selectedImageRelay = BehaviorRelay<[UIImage]>(value: [])
        self.selectedImageViewModels = BehaviorRelay<[SelectedImageViewModelProtocol]>(value: [])
        self.deliverAddImageViewModel = BehaviorRelay<AddImageViewModelProtocol>(value: addImageViewModel)
        self.cameraTap = PublishSubject<Void>()
        self.libraryTap = PublishSubject<Void>()
        self.deleteCellImageInput = PublishSubject<Int>()
        self.deliverSelectedIndex = PublishSubject<Int>()
        
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
        
        self.deleteCellImage = self.deleteCellImageInput
            .asDriver(onErrorDriveWith: .empty())
        
        self.changeSelectedImage = self.deliverSelectedIndex
            .map{_ in Void() }
            .asDriver(onErrorDriveWith: .empty())
        
        self.deliverSelectedIndex
            .subscribe(onNext : {[weak self] index in
                guard let self = self else { return }
                if selectedImageIndex >= 0 && index >= 0 {
                    let cellViewModel = self.selectedImageViewModels.value[selectedImageIndex]
                    cellViewModel.unSelectedCellInput.onNext(())
                    self.selectedImageIndex = index
                }
            })
            .disposed(by: disposeBag)
        
        self.deleteCellImageInput
            .subscribe(onNext : {[weak self] index in
                guard let self = self else { return }
                let cellViewModel = self.selectedImageViewModels.value[self.selectedImageIndex]
                cellViewModel.unSelectedCellInput.onNext(())
                
                var tmpImages = self.selectedImageRelay.value
                var tmpViewModel = self.selectedImageViewModels.value
                let startIndex = self.selectedImageIndex
                tmpImages.remove(at: index)
                
                self.selectedImageRelay.accept(tmpImages)
                
                tmpViewModel.remove(at: index)
                
                for i in 0..<tmpViewModel.count {
                    if tmpViewModel[i].indexPathRow >= index {
                        tmpViewModel[i].indexPathRow -= 1
                    }
                }

                self.selectedImageViewModels.accept(tmpViewModel)
                
                if startIndex == index { // 선택되어있던 indexd 인 경우
                    if index == (self.selectedImageRelay.value.count - 1) {
                        self.selectedImageIndex = startIndex - 1
                    }
                } else if index < startIndex {
                    self.selectedImageIndex = startIndex - 1
                }
                
                print("deleteCellIamgeINput : \(index), after delete index : \(self.selectedImageIndex)")
            })
            .disposed(by: disposeBag)
        
        self.selectedImageRelay
            .subscribe(onNext: {[weak self] images in
                guard let self = self else {return}
                var tmpViewModel : [SelectedImageViewModelProtocol] = self.selectedImageViewModels.value
                
                images.enumerated().forEach { index, image in
                    if self.selectedImageViewModels.value.count <= index {
                        print(index)
                        let selectedImageViewModel = SelectedImageViewModel(index)
                        tmpViewModel.append(selectedImageViewModel)
                        
                        selectedImageViewModel.deleteButtonTap
                            .bind(to : self.deleteCellImageInput)
                            .disposed(by: self.disposeBag)
                        
                        selectedImageViewModel.imageTap
                            .bind(to : self.deliverSelectedIndex)
                            .disposed(by: self.disposeBag)
                    }
                }
                self.selectedImageViewModels.accept(tmpViewModel)
                self.selectedImageIndex = images.count - 1
            })
            .disposed(by: disposeBag)
        

    }
    
    public var sholudPushSelectAlert: Driver<Void>
    public var sholudPushCamera: Driver<Bool>
    public var sholudPushImagePicker: Driver<Bool>
    public var deleteCellImage: Driver<Int>
    public var changeSelectedImage: Driver<Void>
    
    public var cameraTap: PublishSubject<Void>
    public var libraryTap: PublishSubject<Void>
    public var deleteCellImageInput: PublishSubject<Int>
    public var deliverSelectedIndex: PublishSubject<Int>
    
    public var selectedImageRelay: BehaviorRelay<[UIImage]>
    public var selectedImageViewModels: BehaviorRelay<[SelectedImageViewModelProtocol]>
    public var deliverAddImageViewModel: BehaviorRelay<AddImageViewModelProtocol>
}
