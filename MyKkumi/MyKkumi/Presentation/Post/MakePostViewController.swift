//
//  MakePostViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/31/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import PhotosUI

class MakePostViewController : BaseViewController<MakePostViewModelProtocol> {
    var viewModel : MakePostViewModelProtocol!
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupHierarchy() {
        view.addSubview(buttonStack)
        view.addSubview(imageScrollview)
        view.addSubview(selectedImageScrollView)
        imageScrollview.addSubview(imageScrollStackView)
        selectedImageScrollView.addSubview(selectedImageStackView)
        buttonStack.addArrangedSubview(autoPinAddButton)
        buttonStack.addArrangedSubview(addPinButton)
        view.addSubview(contentTextView)
        view.addSubview(AIContentButton)
    }
    
    override func setupDelegate() {
        self.selectedImageScrollView.delegate = self
    }
    
    public override func setupBind(viewModel: MakePostViewModelProtocol) {
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: self.viewModel.viewdidLoad)
            .disposed(by: disposeBag)
        
        self.viewModel.shouldDrawAddButton
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.imageScrollStackView.addArrangedSubview(self.addButton)
            })
            .disposed(by: disposeBag)

        self.viewModel.shouldPushSelectAlert
            .drive(onNext: {[weak self] _ in
                let alert = UIAlertController(title : "포스트 사진추가", message: "", preferredStyle: .actionSheet)
                let library = UIAlertAction(title: "사진 보관함", style: .default) {_ in
                    self?.viewModel.libraryTap.onNext(())
                }
                let camera = UIAlertAction(title: "카메라", style: .default) {_ in
                    self?.viewModel.cameraTap.onNext(())
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(library)
                alert.addAction(camera)
                alert.addAction(cancel)
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.shouldPushImagePicker
            .drive(onNext : {[weak self] _ in
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                configuration.selectionLimit = CountValues.MaxImageCount.value - viewModel.postImageRelay.value.count
                let imagePicker = PHPickerViewController(configuration: configuration)
                imagePicker.delegate = self
                self?.present(imagePicker, animated : true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.shouldPushCamera
            .drive(onNext : {[weak self] _ in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                self?.present(imagePicker, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.contentTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.contentInput)
            .disposed(by: disposeBag)
        
        self.viewModel.sholudAlertOverChar
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Error", message: "글은 2000자 입력 가능하면 해시태그는 20개 까지 가능합니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        
        //MARK: Image
        self.viewModel.sholudDrawImage
            .drive(onNext : {[weak self] images in
                guard let self = self else { return }
                self.imageScrollStackView.subviews.forEach{ $0.removeFromSuperview()}
                self.selectedImageStackView.subviews.forEach{ $0.removeFromSuperview()}
                
                for image in images {
                    let imageView = drawImage(image)
                    self.drawSelectedView(for: image)
                    self.imageScrollStackView.addArrangedSubview(imageView)
                }
                
                if images.count < CountValues.MaxImageCount.value {
                    self.imageScrollStackView.addArrangedSubview(addButton)
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedImageUUID
            .subscribe(onNext: {[weak self] uuid in
                guard let self = self else { return }
                self.scrollToImage(with: uuid)
            })
            .disposed(by: disposeBag)
        
        self.addButton.rx.tap
            .bind(to: viewModel.addImageButtonTap)
            .disposed(by: disposeBag)
        
        //MARK: Pin
        self.addPinButton.rx.tap
            .bind(to: self.viewModel.addPinButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.pinInfoRelay
            .subscribe(onNext: {[weak self] pinMap in
                guard let self = self else { return }
                let selectedImageUUID = viewModel.selectedImageUUID.value
                if let pins = pinMap[selectedImageUUID] {
                    let uuid = self.viewModel.selectedImageUUID.value
                    var selectedImageView : UIView!//pin을 수정할 view
                    for view in selectedImageStackView.arrangedSubviews {
                        if let imageview = view.subviews.first as? UIImageView, imageview.uuidString == uuid {
                            selectedImageView = view
                        }
                    }
                    selectedImageView.subviews.forEach{ subview in
                        if let button = subview as? UIButton {
                            button.removeFromSuperview()
                        }
                    }
                    
                    for pin in pins {
                        let x = viewModel.selectedImageSize.value.size.width * pin.pin.positionX + viewModel.selectedImageSize.value.origin.x
                        let y = viewModel.selectedImageSize.value.size.height * pin.pin.positionY + viewModel.selectedImageSize.value.origin.y
                        
                        let button = UIButton()
                        selectedImageView.addSubview(button)
                        button.translatesAutoresizingMaskIntoConstraints = false
                        button.backgroundColor = .blue
                        button.layer.cornerRadius = 10
                        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
                        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
                        button.leadingAnchor.constraint(equalTo: selectedImageView.leadingAnchor, constant: x).isActive = true
                        button.topAnchor.constraint(equalTo: selectedImageView.topAnchor, constant: y).isActive = true
                        button.uuidString = pin.UUID
                        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
                        button.addGestureRecognizer(panGesture)
                        
                        button.rx.tap
                            .subscribe(onNext: {[weak self] _ in
                                guard let self = self else { return }
                                self.viewModel.pinTap.onNext(pin.UUID)
                            })
                            .disposed(by: disposeBag)
                    }
                }
                
            })
            .disposed(by: disposeBag)
        
        self.viewModel.sholudPushPinOption
           .drive(onNext: {[weak self] uuId in
               let alert = UIAlertController(title : "핀 옵션", message: "", preferredStyle: .actionSheet)
               let library = UIAlertAction(title: "핀 정보 추가", style: .default) {_ in
                   self?.viewModel.modifyPinOptionButtonTap.onNext(uuId)
               }
               let camera = UIAlertAction(title: "핀 삭제", style: .default) {_ in
                   self?.viewModel.deletePinButtonTap.onNext(uuId)
               }
               let cancel = UIAlertAction(title: "취소", style: .cancel)
               
               alert.addAction(library)
               alert.addAction(camera)
               alert.addAction(cancel)
               self?.present(alert, animated: true, completion: nil)
           })
           .disposed(by: disposeBag)
        
        self.viewModel.sholudPresentModifyPin
            .drive(onNext : {[weak self] _ in
                guard let self = self else { return }
                let pinInfoVC = PinInfoViewController()
                pinInfoVC.modalPresentationStyle = .overFullScreen
                pinInfoVC.setupBind(viewModel: self.viewModel.deliverPinInfoViewModel.value)
                self.present(pinInfoVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupLayout() {
        //imageScrollView
        NSLayoutConstraint.activate([
            imageScrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageScrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            imageScrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            imageScrollview.heightAnchor.constraint(equalToConstant: 69)
        ])
        
        NSLayoutConstraint.activate([
            imageScrollStackView.heightAnchor.constraint(equalTo: imageScrollview.heightAnchor),
            imageScrollStackView.topAnchor.constraint(equalTo: imageScrollview.topAnchor),
            imageScrollStackView.leadingAnchor.constraint(equalTo: imageScrollview.leadingAnchor),
            imageScrollStackView.trailingAnchor.constraint(equalTo: imageScrollview.trailingAnchor),
            imageScrollStackView.bottomAnchor.constraint(equalTo: imageScrollview.bottomAnchor),
        ])
        
        //selectedimage
        NSLayoutConstraint.activate([
            selectedImageScrollView.topAnchor.constraint(equalTo: imageScrollview.bottomAnchor, constant: 15),
            selectedImageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            selectedImageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            selectedImageScrollView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            selectedImageStackView.topAnchor.constraint(equalTo: selectedImageScrollView.topAnchor),
            selectedImageStackView.leadingAnchor.constraint(equalTo:selectedImageScrollView.leadingAnchor),
            selectedImageStackView.trailingAnchor.constraint(equalTo:selectedImageScrollView.trailingAnchor),
            selectedImageStackView.bottomAnchor.constraint(equalTo:selectedImageScrollView.bottomAnchor),
            selectedImageStackView.heightAnchor.constraint(equalTo: selectedImageScrollView.heightAnchor)
        ])
        
        //buttonStack
        NSLayoutConstraint.activate([
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            buttonStack.bottomAnchor.constraint(equalTo: contentTextView.topAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            addPinButton.heightAnchor.constraint(equalToConstant: 32),
            autoPinAddButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        //content
        NSLayoutConstraint.activate([
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            contentTextView.heightAnchor.constraint(equalToConstant: 171)
        ])
        
        //aibutton
        NSLayoutConstraint.activate([
            AIContentButton.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor, constant: -8),
            AIContentButton.bottomAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: -8)
        ])
    }
    
    private var imageScrollview : UIScrollView  = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var imageScrollStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var selectedImageScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var selectedImageStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var buttonStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var addPinButton : UIButton = {
        let button = UIButton()
        button.setTitle("핀 추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var autoPinAddButton : UIButton = {
        let button = UIButton()
        button.setTitle("핀 자동 생성", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var contentTextView : UITextView = {
        let textView = UITextView()
        textView.keyboardType = .default
        textView.returnKeyType = .done
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        return textView
    }()
    
    private var AIContentButton : UIButton = {
        let button = UIButton()
        button.setTitle("AI 글 작성", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var addButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "chat"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 69).isActive = true
        button.widthAnchor.constraint(equalToConstant: 69).isActive = true
        return button
    }()
    
    private func calcurateXY() {
        let uuid = self.viewModel.selectedImageUUID.value
        var selectedImageView : UIImageView!
        for view in selectedImageStackView.arrangedSubviews {
            if let imageview = view.subviews.first as? UIImageView, imageview.uuidString == uuid {
                selectedImageView = imageview
            }
        }
        
        guard let image = selectedImageView.image else { return }
        let imageViewSize = selectedImageView.bounds.size
        let imageSize = image.size
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        
        var aspectRatio: CGFloat = 1.0
        var scaledImageSize: CGSize = .zero
        
        aspectRatio = min(scaleWidth, scaleHeight)
        scaledImageSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
        
        let imageX = (imageViewSize.width - scaledImageSize.width) / 2
        let imageY = (imageViewSize.height - scaledImageSize.height) / 2
        
        viewModel.selectedImageSize.accept(CGRect(x: imageX, y: imageY, width: scaledImageSize.width, height: scaledImageSize.height))
    }
    
    @objc private func handlePanGesture(_ gesture : UIPanGestureRecognizer) {
        guard let button = gesture.view as? UIButton else { return }
        
        let translation = gesture.translation(in: self.view)
        
        if gesture.state == .began || gesture.state == .changed {
            let x = button.frame.origin.x + translation.x
            let y = button.frame.origin.y + translation.y
            let imageSize = viewModel.selectedImageSize.value
            
            if x >= imageSize.origin.x &&
                x < imageSize.origin.x + imageSize.size.width - button.frame.size.width &&
                y >= imageSize.origin.y &&
                y < imageSize.origin.y + imageSize.size.height - button.frame.size.height {
                button.frame.origin = CGPoint(x : x, y : y)
                gesture.setTranslation(.zero, in: self.view)
            }
        } else if gesture.state == .ended {
            var values : [String : Any] = [:]
            values["uuId"] = button.uuidString
            values["point"] = CGPoint(x: button.frame.origin.x , y: button.frame.origin.y)
            self.viewModel.pinDragFinish
                .onNext(values)
        }
    }
    
    func drawImage(_ imageInfo : PostImageStruct) -> UIView {
        let view : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let deleteButton : UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("X", for: .normal)
            button.backgroundColor = .red
            return button
        }()
        
        let imageView : UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.load(url: URL(string: imageInfo.imageUrl)!, placeholder: "heart")
            return imageView
        }()
        
        deleteButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.viewModel.deleteImage.onNext(imageInfo.UUID)
            })
            .disposed(by: disposeBag)
        
        imageView.rx.tapGesture
            .subscribe(onNext : {[weak self] _ in
                guard let self = self else { return }
                self.viewModel.selectedImageUUID.accept(imageInfo.UUID)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(deleteButton)
        view.addSubview(imageView)
        view.bringSubviewToFront(deleteButton)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 69),
            view.widthAnchor.constraint(equalToConstant: 69),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        
        return view
    }
    
    private func drawSelectedView(for imageInfo: PostImageStruct) {
        let selectedImageAndPin: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let selectedImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.load(url: URL(string: imageInfo.imageUrl)!, placeholder: "heart") {[weak self] _ in
                self?.calcurateXY()
            }
            imageView.uuidString = imageInfo.UUID // Use hash value as a tag to identify
            return imageView
        }()
        
        selectedImageAndPin.addSubview(selectedImageView)
        selectedImageStackView.addArrangedSubview(selectedImageAndPin)
        
        NSLayoutConstraint.activate([
            selectedImageAndPin.widthAnchor.constraint(equalTo: selectedImageScrollView.widthAnchor),
            selectedImageAndPin.heightAnchor.constraint(equalTo: selectedImageStackView.heightAnchor),
            
            selectedImageView.topAnchor.constraint(equalTo: selectedImageAndPin.topAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: selectedImageAndPin.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: selectedImageAndPin.trailingAnchor),
            selectedImageView.bottomAnchor.constraint(equalTo: selectedImageAndPin.bottomAnchor)
        ])
    }
    
    private func scrollToImage(with uuid: String) {
        if let imageView = selectedImageStackView.arrangedSubviews.compactMap({ $0.subviews.first as? UIImageView }).first(where: { $0.uuidString == uuid }) {
            
            if let index = selectedImageStackView.arrangedSubviews.firstIndex(of: imageView.superview!) {
                let xOffset = CGFloat(index) * selectedImageScrollView.frame.width
                selectedImageScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
            }
            
            calcurateXY()
        }
    }
}

extension MakePostViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        guard let imageView = selectedImageStackView.arrangedSubviews[pageIndex].subviews.first as? UIImageView else { return }
        if let uuid = imageView.uuidString {
            viewModel.selectedImageUUID.accept(uuid)
        }
    }
}

extension MakePostViewController : PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if !results.isEmpty {
            var tmpImages : [UIImage] = []
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    dispatchGroup.enter()
                    itemProvider.loadObject(ofClass: UIImage.self) {(image, error) in
                        tmpImages.append(image as! UIImage)
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main){
                self.viewModel.imagesInput.onNext(tmpImages)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MakePostViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        let isLengthValid = updatedText.count <= 2000
        var hashCount : Int = 0
        if currentText.hasPrefix("#") {
            hashCount = 1
        }
        let componets = currentText.components(separatedBy: "#")
        hashCount += (componets.count - 1)
        let isHashCountValid = hashCount <= 20

        return isLengthValid && isHashCountValid
    }
}
