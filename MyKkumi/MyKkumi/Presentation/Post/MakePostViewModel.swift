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
    var addPinButtonTap : PublishSubject<Void> { get }
    var pinTap : PublishSubject<Int> { get }
    var deletePinButtonTap : PublishSubject<Int> { get }
    var modifyPinOptionButtonTap : PublishSubject<Int> { get }
    var modifyPinButtonTap : PublishSubject<[String : Any]> { get }
    var pinDragFinish : BehaviorSubject<[String : Any]> { get }
    var contentInput : PublishSubject<String?> { get }
}

public protocol MakePostViewModelOutput {
    var sholudPushSelectAlert : Driver<Void> { get }
    var sholudPushImagePicker : Driver<Bool> { get }
    var sholudPushCamera : Driver<Bool> { get }
    var sholudPushModifyPinInfo : Driver<Int> { get }
    var deleteCellImage : Driver<Int> { get }
    var changeSelectedImage : Driver<Void> { get }
    var addPin : Driver<Void> { get }
    var deletePin : Driver<Void> { get }
    var sholudPushPinOption : Driver<Int> { get }
    var dismissModifyInfo : Driver<Void> { get }
}

public protocol MakePostViewModelProtocol : MakePostViewModelOutput,  MakePostViewModelInput{
    var selectedImageRelay : BehaviorRelay<[UIImage]>{ get }
    var selectedImageViewModels : BehaviorRelay<[SelectedImageViewModelProtocol]> { get }
    var deliverAddImageViewModel : BehaviorRelay<AddImageViewModelProtocol>{ get }
    var deliverPinInfoViewModel : BehaviorRelay<PinInfoViewModelProtocol> { get }
    var selectedImageIndex : Int { get }
    var pinsRelay : BehaviorRelay<[[Pin]]> { get }
    var imageSize : BehaviorRelay<CGRect> { get }
    var content : BehaviorRelay<String> { get }
}

public class MakePostViewModel : MakePostViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let addImageViewModel = AddImageViewModel()
    private let pinInfoViewModel = PinInfoViewModel(-1)
    public var selectedImageIndex: Int = -1
    
    public init() {
        self.selectedImageRelay = BehaviorRelay<[UIImage]>(value: [])
        self.selectedImageViewModels = BehaviorRelay<[SelectedImageViewModelProtocol]>(value: [])
        self.deliverAddImageViewModel = BehaviorRelay<AddImageViewModelProtocol>(value: addImageViewModel)
        self.deliverPinInfoViewModel = BehaviorRelay<PinInfoViewModelProtocol>(value: pinInfoViewModel)
        self.pinsRelay = BehaviorRelay<[[Pin]]>(value : [])
        self.imageSize = BehaviorRelay<CGRect>(value: CGRect())
        self.content = BehaviorRelay<String>(value: "")
        
        self.cameraTap = PublishSubject<Void>()
        self.libraryTap = PublishSubject<Void>()
        self.deleteCellImageInput = PublishSubject<Int>()
        self.deliverSelectedIndex = PublishSubject<Int>()
        self.addPinButtonTap = PublishSubject<Void>()
        self.deletePinButtonTap = PublishSubject<Int>()
        self.modifyPinOptionButtonTap = PublishSubject<Int>()
        self.modifyPinButtonTap = PublishSubject<[String : Any]>()
        self.pinTap = PublishSubject<Int>()
        self.pinDragFinish = BehaviorSubject<[String : Any]>(value: ["pId" : -1,
                                                                     "point" : CGPoint()
                                                                    ])
        self.contentInput = PublishSubject<String?>()
        
        //MARK: cameraSubject
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
        
        //MARK: ImageCellSubject
        self.deleteCellImage = self.deleteCellImageInput
            .asDriver(onErrorDriveWith: .empty())
        
        self.changeSelectedImage = self.deliverSelectedIndex
            .map{_ in Void() }
            .asDriver(onErrorDriveWith: .empty())
        
        //MARK: PinSubject
        self.deletePin = self.deletePinButtonTap
            .map{_ in }
            .asDriver(onErrorDriveWith: .empty())
        
        self.addPin = self.addPinButtonTap
            .map{_ in}
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudPushPinOption = self.pinTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudPushModifyPinInfo = self.modifyPinOptionButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.dismissModifyInfo = self.pinInfoViewModel
            .cancelButtonTap
            .map{ _ in }
            .asDriver(onErrorDriveWith: .empty())
        
        self.dismissModifyInfo = self.pinInfoViewModel
            .saveButtonTap
            .map{ _ in}
            .asDriver(onErrorDriveWith: .empty())
        
        self.pinInfoViewModel
            .saveButtonTap
            .subscribe(onNext : {[weak self] index in
                guard let self = self else { return }
                var pinList = self.pinsRelay.value
                let productName = pinInfoViewModel.productName.value
                let purchaseInfo = pinInfoViewModel.purchaseInfo.value
                let productInfo : ProductInfo = ProductInfo(name: productName, url: purchaseInfo)
                print("productInfo \(productInfo), index : \(index)")
                pinList[self.selectedImageIndex][index].productInfo = productInfo
            })
            .disposed(by: disposeBag)
        
        self.modifyPinOptionButtonTap
            .subscribe(onNext: {[weak self] index in
                guard let self = self else { return }
                self.pinInfoViewModel.index = index
                self.deliverPinInfoViewModel.accept(self.pinInfoViewModel)
            })
            .disposed(by: disposeBag)
        
        self.deletePinButtonTap
            .subscribe(onNext : {[weak self] index in
                guard let self = self else { return }
                var pinLinst = self.pinsRelay.value
                pinLinst.remove(at: index)
                self.pinsRelay.accept(pinLinst)
            })
            .disposed(by: disposeBag)
        
        self.pinDragFinish
            .subscribe(onNext : {[weak self] value in
                guard let self = self else { return }
                let pId = value["pId"] as! Int
                let point = value["point"] as! CGPoint
                if pId >= 0 {
                    var pinList = self.pinsRelay.value
                    let positionX = (point.x - self.imageSize.value.origin.x) / self.imageSize.value.size.width
                    let positionY = (point.y - self.imageSize.value.origin.y) / self.imageSize.value.size.height
                    
                    pinList[self.selectedImageIndex][pId].positionX = positionX
                    pinList[self.selectedImageIndex][pId].positionY = positionY
                    self.pinsRelay.accept(pinList)
                }
            })
            .disposed(by: disposeBag)
        
        self.addPinButtonTap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                let pin = Pin(positionX: 0.5, positionY: 0.5)
                var pinList = self.pinsRelay.value
                if pinList.count > self.selectedImageIndex && self.selectedImageIndex >= 0 {
                    pinList[self.selectedImageIndex].append(pin)
                    self.pinsRelay.accept(pinList)
                }
            })
            .disposed(by: disposeBag)
        
        self.modifyPinButtonTap
            .subscribe(onNext : {[weak self] pin in
                guard let self = self else { return }
                var pinList = self.pinsRelay.value
                let pinId : Int = pin["pinID"] as! Int
                let productInfo : ProductInfo = pin["productInfo"] as! ProductInfo
                pinList[self.selectedImageIndex][pinId].productInfo = productInfo
            })
            .disposed(by: disposeBag)
        
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
                var tmpPins  = self.pinsRelay.value
                
                images.enumerated().forEach { index, image in
                    if self.selectedImageViewModels.value.count <= index {
                        let selectedImageViewModel = SelectedImageViewModel(index)
                        tmpViewModel.append(selectedImageViewModel)
                        
                        selectedImageViewModel.deleteButtonTap
                            .bind(to : self.deleteCellImageInput)
                            .disposed(by: self.disposeBag)
                        
                        selectedImageViewModel.imageTap
                            .bind(to : self.deliverSelectedIndex)
                            .disposed(by: self.disposeBag)
                        
                        tmpPins.append([])
                    }
                }
                
                self.pinsRelay.accept(tmpPins)
                self.selectedImageViewModels.accept(tmpViewModel)
                self.selectedImageIndex = images.count - 1
            })
            .disposed(by: disposeBag)
        
        self.contentInput
            .subscribe(onNext: {[weak self] content in
                if let content = content {
                    self?.content.accept(content)
                }
            })
            .disposed(by: disposeBag)
    }
    
    public var sholudPushSelectAlert: Driver<Void>
    public var sholudPushCamera: Driver<Bool>
    public var sholudPushImagePicker: Driver<Bool>
    public var deleteCellImage: Driver<Int>
    public var changeSelectedImage: Driver<Void>
    public var addPin: Driver<Void>
    public var deletePin: Driver<Void>
    public var sholudPushPinOption: Driver<Int>
    public var sholudPushModifyPinInfo: Driver<Int>
    public var dismissModifyInfo: Driver<Void>
    
    public var cameraTap: PublishSubject<Void>
    public var libraryTap: PublishSubject<Void>
    public var deleteCellImageInput: PublishSubject<Int>
    public var deliverSelectedIndex: PublishSubject<Int>
    public var addPinButtonTap: PublishSubject<Void>
    public var pinTap: PublishSubject<Int>
    public var deletePinButtonTap: PublishSubject<Int>
    public var modifyPinOptionButtonTap: PublishSubject<Int>
    public var modifyPinButtonTap: PublishSubject<[String : Any]>
    public var pinDragFinish: BehaviorSubject<[String : Any]>
    public var contentInput: PublishSubject<String?>
    
    public var selectedImageRelay: BehaviorRelay<[UIImage]>
    public var selectedImageViewModels: BehaviorRelay<[SelectedImageViewModelProtocol]>
    public var deliverAddImageViewModel: BehaviorRelay<AddImageViewModelProtocol>
    public var deliverPinInfoViewModel: BehaviorRelay<PinInfoViewModelProtocol>
    public var pinsRelay: BehaviorRelay<[[Pin]]>
    public var imageSize: BehaviorRelay<CGRect>
    public var content: BehaviorRelay<String>
}
