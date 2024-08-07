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
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupHierarchy() {
        view.addSubview(imageCollectionView)
        view.addSubview(selectedImageAndPin)
        selectedImageAndPin.addSubview(selectedImageView)
        view.addSubview(buttonStack)
        buttonStack.addArrangedSubview(autoPinAddButton)
        buttonStack.addArrangedSubview(addPinButton)
        view.addSubview(contentTextFiled)
        view.addSubview(AIContentButton)
    }
    
    override func setupDelegate() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    public override func setupBind(viewModel: MakePostViewModelProtocol) {
        self.viewModel = viewModel
        
        self.viewModel.sholudPushSelectAlert
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
        
        self.viewModel.sholudPushImagePicker
            .drive(onNext : {[weak self] result in
                if result {
                    var configuration = PHPickerConfiguration()
                    configuration.filter = .images
                    configuration.selectionLimit = 10 - viewModel.selectedImageRelay.value.count
                    let imagePicker = PHPickerViewController(configuration: configuration)
                    imagePicker.delegate = self
                    self?.present(imagePicker, animated : true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.sholudPushCamera
            .drive(onNext : {[weak self] result in
                if result {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    self?.present(imagePicker, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        self.contentTextFiled.rx.text.changed
            .bind(to: self.viewModel.contentInput)
            .disposed(by: disposeBag)
        
        //MARK: ImageCellBind
        self.viewModel.changeSelectedImage
            .drive(onNext: {[weak self] _ in
                self?.selectedImageView.image = viewModel.selectedImageRelay.value[viewModel.selectedImageIndex]
            })
            .disposed(by: disposeBag)
        
        self.viewModel.deleteCellImage
            .drive(onNext: {[weak self] index in
                guard let self = self else { return }
                let indexPath = IndexPath(item : index, section : 0)
                
                if self.viewModel.selectedImageIndex >= 0 {
                    self.selectedImageView.image = viewModel.selectedImageRelay.value[viewModel.selectedImageIndex]
                    
                    calcurateXY()
                }
                self.imageCollectionView.performBatchUpdates({
                    self.imageCollectionView.deleteItems(at: [indexPath])
                }, completion: nil)
            })
            .disposed(by: disposeBag)
        
        //MARK: Pin
        self.addPinButton.rx.tap
            .bind(to: viewModel.addPinButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.sholudPushPinOption
            .drive(onNext: {[weak self] index in
                let alert = UIAlertController(title : "핀 옵션", message: "", preferredStyle: .actionSheet)
                let library = UIAlertAction(title: "핀 정보 추가", style: .default) {_ in
                    self?.viewModel.modifyPinOptionButtonTap.onNext(index)
                }
                let camera = UIAlertAction(title: "핀 삭제", style: .default) {_ in
                    self?.viewModel.deletePinButtonTap.onNext(index)
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(library)
                alert.addAction(camera)
                alert.addAction(cancel)
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.sholudPushModifyPinInfo
            .drive(onNext : {[weak self] index in
                let pinInfoVC = PinInfoViewController()
                let delegate = PinInfoPresentationControllerDelegate()
                pinInfoVC.setupBind(viewModel: viewModel.deliverPinInfoViewModel.value)
                pinInfoVC.transitioningDelegate = delegate
                pinInfoVC.modalPresentationStyle = .custom
                self?.present(pinInfoVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.dismissModifyInfo
            .drive(onNext: {[weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.addPin
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                if viewModel.selectedImageIndex >= 0 {
                    let pins = viewModel.pinsRelay.value[viewModel.selectedImageIndex]
                    self.selectedImageAndPin.subviews.forEach{ subview in
                        if let button = subview as? UIButton {
                            button.removeFromSuperview()
                        }
                    }
                    for index in (0..<pins.count) {
                        let x = viewModel.imageSize.value.size.width * pins[index].positionX + viewModel.imageSize.value.origin.x
                        let y = viewModel.imageSize.value.size.height * pins[index].positionY + viewModel.imageSize.value.origin.y

                        let button = UIButton()
                        self.selectedImageAndPin.addSubview(button)
                        button.translatesAutoresizingMaskIntoConstraints = false
                        button.backgroundColor = .blue
                        button.layer.cornerRadius = 10
                        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
                        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
                        button.leadingAnchor.constraint(equalTo: self.selectedImageView.leadingAnchor, constant: x).isActive = true
                        button.topAnchor.constraint(equalTo: self.selectedImageView.topAnchor, constant: y).isActive = true
                        button.tag = index
                        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
                        button.addGestureRecognizer(panGesture)
                        button.rx.tap
                            .map{button.tag}
                            .bind(to: viewModel.pinTap)
                            .disposed(by: disposeBag)
                    }
                }
            })
            .disposed(by: disposeBag)
            
    }
    
    override func setupLayout() {
        //imageCollectionView
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 69)
        ])
        
        //selectedImageView
        NSLayoutConstraint.activate([
            selectedImageAndPin.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 15),
            selectedImageAndPin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            selectedImageAndPin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            selectedImageAndPin.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: selectedImageAndPin.topAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: selectedImageAndPin.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: selectedImageAndPin.trailingAnchor),
            selectedImageView.bottomAnchor.constraint(equalTo: selectedImageAndPin.bottomAnchor)
        ])
        
        //buttonStack
        NSLayoutConstraint.activate([
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            buttonStack.bottomAnchor.constraint(equalTo: contentTextFiled.topAnchor, constant: -12)
        ])
        
        //content
        NSLayoutConstraint.activate([
            contentTextFiled.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            contentTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            contentTextFiled.heightAnchor.constraint(equalToConstant: 171)
        ])
        
        //aibutton
        NSLayoutConstraint.activate([
            AIContentButton.trailingAnchor.constraint(equalTo: contentTextFiled.trailingAnchor, constant: -8),
            AIContentButton.bottomAnchor.constraint(equalTo: contentTextFiled.bottomAnchor, constant: -8)
        ])
    }
    
    private var buttonStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var imageCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: SelectedImageFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SelectedImageCell.self, forCellWithReuseIdentifier: SelectedImageCell.cellID)
        collectionView.register(AddImageCell.self, forCellWithReuseIdentifier: AddImageCell.cellID)
        return collectionView
    }()
    
    private var selectedImageAndPin : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var selectedImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    private var contentTextFiled : UITextView = {
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
    
    private func calcurateXY() {
        guard let image = self.selectedImageView.image else { return }
        let imageViewSize = self.selectedImageView.bounds.size
        let imageSize = image.size
                
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        
        var aspectRatio: CGFloat = 1.0
        var scaledImageSize: CGSize = .zero
        
        aspectRatio = min(scaleWidth, scaleHeight)
        scaledImageSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
        
        let imageX = (imageViewSize.width - scaledImageSize.width) / 2
        let imageY = (imageViewSize.height - scaledImageSize.height) / 2
        
        viewModel.imageSize.accept(CGRect(x: imageX, y: imageY, width: scaledImageSize.width, height: scaledImageSize.height))
    }
    
    @objc private func handlePanGesture(_ gesture : UIPanGestureRecognizer) {
        guard let button = gesture.view as? UIButton else { return }
        
        let translation = gesture.translation(in: self.view)
        
        if gesture.state == .began || gesture.state == .changed {
            let x = button.frame.origin.x + translation.x
            let y = button.frame.origin.y + translation.y
            let imageSize = viewModel.imageSize.value
            
            if x >= imageSize.origin.x && x < imageSize.origin.x + imageSize.size.width - button.frame.size.width && y >= imageSize.origin.y && y < imageSize.origin.y + imageSize.size.height - button.frame.size.height {
                button.frame.origin = CGPoint(x : x, y : y)
                gesture.setTranslation(.zero, in: self.view)
            }
        } else if gesture.state == .ended {
            var values : [String : Any] = [:]
            values["pId"] = button.tag
            values["point"] = CGPoint(x: button.frame.origin.x , y: button.frame.origin.y)
            self.viewModel.pinDragFinish
                .onNext(values)
        }
    }
}

extension MakePostViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageCount = viewModel.selectedImageRelay.value.count
        if imageCount == 10 {
            return 10
        } else {
            return imageCount + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCount = viewModel.selectedImageRelay.value.count
        if indexPath.row == imageCount && imageCount < 10 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.cellID, for: indexPath) as! AddImageCell
            cell.setBind(viewModel: viewModel.deliverAddImageViewModel.value)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCell.cellID, for: indexPath) as! SelectedImageCell
            cell.imageView.image = viewModel.selectedImageRelay.value[indexPath.row]
            cell.setBind(viewModel: viewModel.selectedImageViewModels.value[indexPath.row])
            if indexPath.row == self.viewModel.selectedImageIndex {
                cell.viewModel.imageTap.onNext(imageCount - 1)
            } else {
                cell.viewModel.unSelectedCellInput.onNext(())
            }
            return cell
        }
    }
}

extension MakePostViewController : PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if !results.isEmpty {
            var tmpImages = viewModel.selectedImageRelay.value
            let startInx = tmpImages.count
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
                self.viewModel.selectedImageRelay.accept(tmpImages)
                self.selectedImageView.image = tmpImages.last
                
                self.calcurateXY()
                
                let newIndexPaths = (startInx..<tmpImages.count).map { IndexPath(item: $0, section: 0) }
                self.imageCollectionView.performBatchUpdates({
                    self.imageCollectionView.insertItems(at: newIndexPaths)
                }, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
