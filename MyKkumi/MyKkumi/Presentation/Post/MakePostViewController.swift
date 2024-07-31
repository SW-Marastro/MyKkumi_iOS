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

class MakePostViewController : BaseViewController<MakePostViewModelProtocol> {
    var viewModel : MakePostViewModelProtocol!
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupHierarchy() {
        view.addSubview(mainStack)
        mainStack.addSubview(imageCollectionView)
        mainStack.addSubview(selectedImageView)
        mainStack.addSubview(buttonStack)
        buttonStack.addSubview(addPinButton)
        buttonStack.addSubview(autoPinAddButton)
        mainStack.addSubview(contentTextFiled)
        mainStack.addSubview(AIContentButton)
    }
    
    override func setupDelegate() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    public override func setupBind(viewModel: MakePostViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    override func setupLayout() {
        //MainStack
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        //collectionView
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: mainStack.topAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -12),
            imageCollectionView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 12)
        ])
        
        //selectedImage
        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 15),
            selectedImageView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            selectedImageView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -12)
        ])
        
        //ButtonStack
        NSLayoutConstraint.activate([
            buttonStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -12),
        ])
        
        
        //contentTextField
        NSLayoutConstraint.activate([
            contentTextFiled.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 12),
            contentTextFiled.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            contentTextFiled.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor),
            contentTextFiled.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor)
        ])
        
        //AIContentBUtton
        NSLayoutConstraint.activate([
            AIContentButton.trailingAnchor.constraint(equalTo: contentTextFiled.trailingAnchor, constant: -8),
            AIContentButton.bottomAnchor.constraint(equalTo: contentTextFiled.bottomAnchor, constant: -8)
        ])
        
        
    }
    
    private var mainStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var autoPinAddButton : UIButton = {
        let button = UIButton()
        button.setTitle("핀 자동 생성", for: .normal)
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
            return cell
        } else {
            if(indexPath.row == imageCount) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.cellID, for: indexPath) as! AddImageCell
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCell.cellID, for: indexPath) as! SelectedImageCell
                cell.imageView.image = viewModel.selectedImageRelay.value[indexPath.row]
                return cell
            }
        }
    }
    
    
}

extension MakePostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
