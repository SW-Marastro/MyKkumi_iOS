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
    }
    
    override func setupHierarchy() {
        view.addSubview(imageCollectionView)
        view.addSubview(selectedImageView)
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
        
        viewModel.sholudPushImagePicker
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
        
        viewModel.sholudPushCamera
            .drive(onNext : {[weak self] result in
                if result {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    self?.present(imagePicker, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.deleteCellImage
            .drive(onNext : {[weak self] result in
                if result {
                    self?.imageCollectionView.reloadData()
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
            selectedImageView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 15),
            selectedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            selectedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            selectedImageView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -12)
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
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PostImageCollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SelectedImageCell.self, forCellWithReuseIdentifier: SelectedImageCell.cellID)
        collectionView.register(AddImageCell.self, forCellWithReuseIdentifier: AddImageCell.cellID)
        return collectionView
    }()
    
    private var selectedImageView : UIImageView = {
        let imageView = UIImageView()
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
        if imageCount == 10 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCell.cellID, for: indexPath) as! SelectedImageCell
            cell.imageView.image = viewModel.selectedImageRelay.value[indexPath.row]
            cell.setBind(viewModel: viewModel.selectedImageViewModels.value[indexPath.row])
            return cell
        } else {
            if(indexPath.row == imageCount) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.cellID, for: indexPath) as! AddImageCell
                cell.setBind(viewModel: viewModel.deliverAddImageViewModel.value)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCell.cellID, for: indexPath) as! SelectedImageCell
                cell.imageView.image = viewModel.selectedImageRelay.value[indexPath.row]
                cell.setBind(viewModel: viewModel.selectedImageViewModels.value[indexPath.row])
                return cell
            }
        }
    }
}

extension MakePostViewController : PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if !results.isEmpty {
            var tmpImages = viewModel.selectedImageRelay.value
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
                self.imageCollectionView.reloadData()
                self.selectedImageView.image = tmpImages[0]
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
