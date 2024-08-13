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
    var viewdidLoad : PublishSubject<Void> { get }
    //camera & library & content
    var addImageButtonTap : PublishSubject<Void> { get }
    var libraryTap : PublishSubject<Void> { get }
    var cameraTap : PublishSubject<Void> { get }
    var contentInput : PublishSubject<String> { get }
    var overChar : PublishSubject<Void> { get }
    
    //Images
    var imagesInput : PublishSubject<[UIImage]> { get }
    var putImagesInServer : PublishSubject<[ImageData]> { get }
    var deleteImage : PublishSubject<String> { get }
    
    //Pins
    var addPinButtonTap : PublishSubject<Void> { get }
    var pinTap : PublishSubject<String> { get }
    var pinDragFinish : PublishSubject<[String: Any]> { get }
    var modifyPinOptionButtonTap : PublishSubject<String> { get }
    var deletePinButtonTap : PublishSubject<String> { get }
    
    //navBar
    var backButtontap : PublishSubject<Void> { get }
    var saveButtonTap : PublishSubject<Void> { get }
}

public protocol MakePostViewModelOutput {
    var shouldPushSelectAlert : Driver<Void> { get }
    var shouldPushImagePicker : Driver<Void> { get }
    var shouldPushCamera : Driver<Void> { get }
    var sholudDrawImage : Driver<[PostImageStruct]> { get }
    var sholudDrawSelectedImage : Driver<String> { get }
    var shouldDrawAddButton : Driver<Void> { get }
    var sholudPushPinOption : Driver<String> { get }
    var sholudPresentModifyPin : Driver<String> { get }
    var sholudAlertOverChar : Driver<Void> { get }
    var dismissVC : Driver<Void> { get }
    var sholudPresentCategory : Driver<Void> { get }
}

public protocol MakePostViewModelProtocol : MakePostViewModelOutput,  MakePostViewModelInput{
    var contentRelay : BehaviorRelay<String> { get }
    var postImageRelay : BehaviorRelay<[PostImageStruct]> { get }
    var selectedImageUUID : BehaviorRelay<String> { get }
    var pinInfoRelay : BehaviorRelay<[String : [PinInfoStrcut]]> { get }
    var selectedImageSize : BehaviorRelay<CGRect> { get }
    var deliverPinInfoViewModel : BehaviorRelay<PinInfoViewModelProtocol> { get }
    var deliverCategoryViewModel : BehaviorRelay<PostCategoryViewModelProtocol> { get }
    var subCategories : BehaviorRelay<Int> { get }
}
 
public class MakePostViewModel : MakePostViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let makePostUsecase : MakePostUseCase
    private let pinInfoViewModel  = PinInfoViewModel("nil")
    private let postCategoryViewModel = PostCategoryViewModel()
    
    public init(makePostUsecase : MakePostUseCase = DependencyInjector.shared.resolve(MakePostUseCase.self)) {
        self.makePostUsecase = makePostUsecase
        
        self.addImageButtonTap = PublishSubject<Void>()
        self.libraryTap = PublishSubject<Void>()
        self.cameraTap = PublishSubject<Void>()
        self.contentInput = PublishSubject<String>()
        self.imagesInput = PublishSubject<[UIImage]>()
        self.putImagesInServer = PublishSubject<[ImageData]>()
        self.viewdidLoad = PublishSubject<Void>()
        self.deleteImage = PublishSubject<String>()
        self.addPinButtonTap = PublishSubject<Void>()
        self.pinTap = PublishSubject<String>()
        self.pinDragFinish = PublishSubject<[String : Any]>()
        self.modifyPinOptionButtonTap = PublishSubject<String>()
        self.deletePinButtonTap = PublishSubject<String>()
        self.overChar = PublishSubject<Void>()
        self.saveButtonTap = PublishSubject<Void>()
        self.backButtontap = PublishSubject<Void>()
        
        self.contentRelay = BehaviorRelay<String>(value: "")
        self.postImageRelay = BehaviorRelay<[PostImageStruct]>(value: [])
        self.selectedImageUUID = BehaviorRelay<String>(value: "nil")
        self.pinInfoRelay = BehaviorRelay<[String : [PinInfoStrcut]]>(value: [:])
        self.selectedImageSize = BehaviorRelay<CGRect>(value: CGRect())
        self.deliverPinInfoViewModel = BehaviorRelay<PinInfoViewModelProtocol>(value: pinInfoViewModel)
        self.deliverCategoryViewModel = BehaviorRelay<PostCategoryViewModelProtocol>(value : postCategoryViewModel)
        self.subCategories = BehaviorRelay<Int>(value: 0)
        
        self.shouldDrawAddButton = self.viewdidLoad
            .asDriver(onErrorDriveWith: .empty())
        
        self.shouldPushCamera = self.cameraTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.shouldPushImagePicker = self.libraryTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.shouldPushSelectAlert = self.addImageButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudDrawImage = self.postImageRelay
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudDrawSelectedImage = self.selectedImageUUID
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudPushPinOption = self.pinTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudPresentModifyPin = self.modifyPinOptionButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudAlertOverChar = self.overChar
            .asDriver(onErrorDriveWith: .empty())
        
        self.dismissVC = self.backButtontap
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudPresentCategory = self.saveButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.imagesInput
            .subscribe(onNext: {[weak self] images in
                guard let self = self else { return }
                let dispatchGroup = DispatchGroup()
                var imagesData : [ImageData] = []
                for image in images {
                    dispatchGroup.enter()
                    self.makePostUsecase.getPresignedUrl()
                        .subscribe(onSuccess: {result in
                            if case let .success(url) = result {
                                let resizedImage = image.resized(toMaxSize: CGSize(width: 1024, height: 1024))
                                let imageToData = resizedImage.jpegData(compressionQuality: 1)!
                                let imageData = ImageData(data: imageToData, url: url)
                                imagesData.append(imageData)
                            }
                            dispatchGroup.leave()
                        }, onFailure: { error in
                            print("Error corrured : \(error)")
                            dispatchGroup.leave()
                        })
                        .disposed(by: self.disposeBag)
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.putImagesInServer
                        .onNext(imagesData)
                }
            })
            .disposed(by: disposeBag)
        
        self.putImagesInServer
            .subscribe(onNext : {[weak self] imageDatas in
                guard let self = self else { return }
                var tmpInfo = self.postImageRelay.value
                let dispatchGroup = DispatchGroup()
                var pinInfo = self.pinInfoRelay.value
                
                for imageData in imageDatas {
                    dispatchGroup.enter()
                    makePostUsecase.putImage(url: imageData.url, image: imageData.data)
                        .subscribe(onSuccess: { result in
                            if case let .success(check) = result {
                                if check {
                                    let uuId = UUID().uuidString + ".jpeg"
                                    let imageUrl = imageData.url.components(separatedBy: "?").first!
                                    let postImage = PostImageStruct(UUID: uuId, imageUrl: imageUrl)
                                    tmpInfo.append(postImage)
                                }
                            }
                            dispatchGroup.leave()
                        }, onFailure: { error in
                            print("Error corrured : \(error)")
                            dispatchGroup.leave()
                        })
                        .disposed(by: self.disposeBag)
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.postImageRelay.accept(tmpInfo)
                    if let lastimage = tmpInfo.last {
                        self.selectedImageUUID.accept(lastimage.UUID)
                        self.pinInfoRelay.accept(pinInfo)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        self.deleteImage
            .subscribe(onNext: {[weak self] uuId in
                guard let self = self else { return }
                var tmpImage = self.postImageRelay.value
                var selectedUuid = self.selectedImageUUID.value
                var index : Int = 0
                for image in tmpImage {
                    if image.UUID == uuId {
                        tmpImage.remove(at: index)
                        break
                    }
                    index += 1
                }
                
                if uuId == selectedUuid {
                    if index >= tmpImage.count {
                        selectedUuid = tmpImage.last?.UUID ?? "nil"
                    } else {
                        selectedUuid = tmpImage[index].UUID
                    }
                    self.selectedImageUUID.accept(selectedUuid)
                }
                
                self.postImageRelay.accept(tmpImage)
            })
            .disposed(by: disposeBag)
        
        self.addPinButtonTap
            .subscribe(onNext : {[weak self] _ in
                guard let self = self else { return }
                var tmpPins = self.pinInfoRelay.value
                let nowImageUuid = self.selectedImageUUID.value
                
                if let pins = tmpPins[nowImageUuid] {
                    if pins.count < CountValues.MaxPinCount.value {
                        let uuid = UUID().uuidString + "button"
                        let pin = Pin(positionX: 0.5, positionY: 0.5)
                        let pinInfo = PinInfoStrcut(UUID: uuid, pin: pin)
                        tmpPins[nowImageUuid]!.append(pinInfo)
                        self.pinInfoRelay.accept(tmpPins)
                    }
                } else {
                    var newArray : [PinInfoStrcut] = []
                    let uuid = UUID().uuidString + "button"
                    let pin = Pin(positionX: 0.5, positionY: 0.5)
                    let pinInfo = PinInfoStrcut(UUID: uuid, pin: pin)
                    newArray.append(pinInfo)
                    tmpPins[nowImageUuid] = newArray
                    self.pinInfoRelay.accept(tmpPins)
                }
            })
            .disposed(by: disposeBag)
        
        self.pinDragFinish
            .subscribe(onNext: {[weak self] value in
                guard let self = self else { return }
                let uuId = value["uuId"] as! String
                let point = value["point"] as! CGPoint
                
                var pinInfo = self.pinInfoRelay.value
                if let pins = pinInfo[self.selectedImageUUID.value] {
                    for (index, pin) in pins.enumerated() {
                        if pin.UUID == uuId {
                            pinInfo[self.selectedImageUUID.value]![index].pin.positionX = (point.x - self.selectedImageSize.value.origin.x) / self.selectedImageSize.value.size.width
                            pinInfo[self.selectedImageUUID.value]![index].pin.positionY = (point.y - self.selectedImageSize.value.origin.y) / self.selectedImageSize.value.size.height
                        }
                    }
                }
                self.pinInfoRelay.accept(pinInfo)
            })
            .disposed(by: disposeBag)
        
        self.deletePinButtonTap
            .subscribe(onNext: {[weak self] uuId in
                guard let self = self else { return }
                
                var pinInfo = self.pinInfoRelay.value
                if let pins = pinInfo[self.selectedImageUUID.value] {
                    for (index, pin) in pins.enumerated() {
                        if pin.UUID == uuId {
                            pinInfo[self.selectedImageUUID.value]!.remove(at: index)
                        }
                    }
                }
                self.pinInfoRelay.accept(pinInfo)
            })
            .disposed(by: disposeBag)
        
        self.modifyPinOptionButtonTap
            .subscribe(onNext: {[weak self] uuId in
                guard let self = self else { return }
                self.pinInfoViewModel.uuId = uuId
                self.deliverPinInfoViewModel.accept(self.pinInfoViewModel)
            })
            .disposed(by: disposeBag)
        
        self.pinInfoViewModel.saveButtonTap
            .subscribe(onNext: {[weak self] uuId in
                guard let self = self else { return }
                var pinInfo = self.pinInfoRelay.value
                if pinInfoViewModel.productName.value == "" {
                    self.pinInfoViewModel.alertNameBlankInput.onNext(Void())
                    return
                }
                if let pins = pinInfo[self.selectedImageUUID.value] {
                    for (index, pin) in pins.enumerated() {
                        if pin.UUID == uuId {
                            let productName = pinInfoViewModel.productName.value
                            let purchaseInfo = pinInfoViewModel.purchaseInfo.value
                            let productInfo : ProductInfo = ProductInfo(name: productName, url: purchaseInfo)
                            pinInfo[self.selectedImageUUID.value]![index].pin.productInfo = productInfo
                        }
                    }
                }
                self.pinInfoViewModel.saveCompleteInput.onNext(uuId)
                self.pinInfoRelay.accept(pinInfo)
            })
            .disposed(by: disposeBag)
        
        self.contentInput
            .subscribe(onNext: {[weak self] value in
                guard let self = self else { return }
                var hashCount : Int = 0
                print(value)
                if value.count > CountValues.MaxContentCount.value {
                    self.overChar.onNext(())
                    return
                }
                
                if value.hasPrefix("#") {
                    hashCount = 1
                }
                
                let componets = value.components(separatedBy: "#")
                hashCount += (componets.count - 1)
                if hashCount > CountValues.MaxHashTagCount.value {
                    self.overChar.onNext(())
                    return
                }
                
                contentRelay.accept(value)
            })
            .disposed(by: disposeBag)
        
        self.postCategoryViewModel.categoryButtonTap
            .subscribe(onNext: {[weak self] id in
                guard let self = self else {return}
                self.subCategories.accept(id)
            })
            .disposed(by: disposeBag)
        
        let saveResult = self.postCategoryViewModel.completeButtonTap
            .flatMap {[weak self] _ in
                if let self = self {
                    let subCategoryId = self.subCategories.value
                    let content = self.contentRelay.value
                    let imagesUrl = self.postImageRelay.value
                    let pinInfo = self.pinInfoRelay.value
                    var images : [Image] = []
                    for image in imagesUrl {
                        let pins = pinInfo[image.UUID]?.compactMap{$0.pin}
                        let url = image.imageUrl
                        let tmpImage = Image(url: url, pins: pins!)
                        images.append(tmpImage)
                    }
                    
                    let makePostVO = MakePostVO(subCategoryId: subCategoryId, content: content, images: images)
                    
                    return makePostUsecase.uploadPost(makePostVO)
                }
                
                return Single.error(MakePostError.unknownError(ErrorVO(errorCode: "self error", message: "아직 생성되지 않았음", detail: "guard let self error")))
            }
            .share()
        
        self.postCategoryViewModel.dismissView = saveResult
            .compactMap { $0.successValue()}
            .asDriver(onErrorDriveWith: .empty())
        
        
    }

    public var addImageButtonTap: PublishSubject<Void>
    public var libraryTap: PublishSubject<Void>
    public var cameraTap: PublishSubject<Void>
    public var contentInput: PublishSubject<String>
    public var imagesInput: PublishSubject<[UIImage]>
    public var putImagesInServer: PublishSubject<[ImageData]>
    public var viewdidLoad: PublishSubject<Void>
    public var deleteImage: PublishSubject<String>
    public var addPinButtonTap: PublishSubject<Void>
    public var pinTap: PublishSubject<String>
    public var pinDragFinish: PublishSubject<[String : Any]>
    public var modifyPinOptionButtonTap: PublishSubject<String>
    public var deletePinButtonTap: PublishSubject<String>
    public var overChar: PublishSubject<Void>
    public var backButtontap: PublishSubject<Void>
    public var saveButtonTap: PublishSubject<Void>
    
    public var shouldPushCamera: Driver<Void>
    public var shouldPushImagePicker: Driver<Void>
    public var shouldPushSelectAlert: Driver<Void>
    public var shouldDrawAddButton: Driver<Void>
    public var sholudDrawImage: Driver<[PostImageStruct]>
    public var sholudDrawSelectedImage: Driver<String>
    public var sholudPushPinOption: Driver<String>
    public var sholudPresentModifyPin: Driver<String>
    public var sholudAlertOverChar: Driver<Void>
    public var dismissVC: Driver<Void>
    public var sholudPresentCategory: Driver<Void>

    public var contentRelay: BehaviorRelay<String>
    public var postImageRelay: BehaviorRelay<[PostImageStruct]>
    public var selectedImageUUID: BehaviorRelay<String>
    public var pinInfoRelay: BehaviorRelay<[String : [PinInfoStrcut]]>
    public var selectedImageSize: BehaviorRelay<CGRect>
    public var deliverPinInfoViewModel: BehaviorRelay<any PinInfoViewModelProtocol>
    public var deliverCategoryViewModel: BehaviorRelay<any PostCategoryViewModelProtocol>
    public var subCategories: BehaviorRelay<Int>
}

public struct ImageData {
    let data : Data
    let url : String
    
    init(data: Data, url: String) {
        self.data = data
        self.url = url
    }
}
