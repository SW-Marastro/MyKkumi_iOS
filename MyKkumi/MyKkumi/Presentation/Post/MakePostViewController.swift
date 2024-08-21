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
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func setupHierarchy() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(selectedImageScrollView)
        mainStackView.addArrangedSubview(imageContainView)
        mainStackView.addArrangedSubview(emptyView)
        mainStackView.addArrangedSubview(buttonView)
        mainStackView.addArrangedSubview(contentView)
        mainStackView.addArrangedSubview(categoryView)
        mainStackView.addArrangedSubview(completeButtonView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(contentTextView)
        contentView.addSubview(placeHolderLabel)
        imageContainView.addSubview(imageScrollview)
        imageScrollview.addSubview(imageScrollStackView)
        buttonView.addSubview(buttonStack)
        selectedImageScrollView.addSubview(selectedImageStackView)
        buttonStack.addArrangedSubview(addPinButton)
        buttonStack.addArrangedSubview(autoPinAddButton)
        completeButtonView.addSubview(completeButton)
        categoryView.addSubview(categoryLabel)
        categoryView.addSubview(categoryMultiView)
        
        
        self.categoryMultiView.translatesAutoresizingMaskIntoConstraints = false
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.titleView = navTitle
    }
    
    override func setupDelegate() {
        self.selectedImageScrollView.delegate = self
        self.contentTextView.delegate = self
    }
    
    public override func setupBind(viewModel: MakePostViewModelProtocol) {
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: self.viewModel.viewdidLoad)
            .disposed(by: disposeBag)
        
        self.viewModel.shouldDrawAddButton
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                basicView.addSubview(addImageButton)
                selectedImageStackView.addArrangedSubview(basicView)
                
                NSLayoutConstraint.activate([
                    basicView.widthAnchor.constraint(equalTo: selectedImageScrollView.widthAnchor),
                    basicView.heightAnchor.constraint(equalTo: selectedImageScrollView.heightAnchor),
                    
                    addImageButton.centerXAnchor.constraint(equalTo: basicView.centerXAnchor),
                    addImageButton.centerYAnchor.constraint(equalTo: basicView.centerYAnchor),
                    addImageButton.heightAnchor.constraint(equalToConstant: 47),
                    addImageButton.widthAnchor.constraint(equalToConstant: 122)
                ])
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
        
        self.viewModel.contentRelay
            .subscribe(onNext: {[weak self] string in
                guard let self = self else { return }
                if string != "" {
                    if self.viewModel.postImageRelay.value.count != 0 && self.viewModel.subCategories.value != 0{
                        self.completeButton.backgroundColor = AppColor.primary.color
                        self.completeButton.setAttributedTitle(NSAttributedString(string : "등록하기", attributes: Typography.body15SemiBold(color: AppColor.white).attributes), for: .normal)
                        self.completeButton.isEnabled = true
                    } else {
                        self.completeButton.isEnabled = false
                    }
                } else {
                    self.completeButton.isEnabled = false
                }
            })
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
                print(images)
                guard let self = self else { return }
                self.imageScrollStackView.subviews.forEach{ $0.removeFromSuperview()}
                self.selectedImageStackView.subviews.forEach{ $0.removeFromSuperview()}
                
                for image in images {
                    self.drawImage(image)
                    self.drawSelectedView(for: image)
                }
                
                if images.count < CountValues.MaxImageCount.value && images.count > 0{
                    self.imageScrollStackView.addArrangedSubview(addButton)
                    NSLayoutConstraint.activate([
                        addButton.heightAnchor.constraint(equalTo: imageScrollStackView.heightAnchor),
                        addButton.widthAnchor.constraint(equalTo: imageScrollStackView.heightAnchor)
                    ])
                }
                
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedImageUUID
            .subscribe(onNext: {[weak self] uuid in
                guard let self = self else { return }
                self.scrollToImage(with: uuid)
                self.viewModel.pinInfoRelay.accept(self.viewModel.pinInfoRelay.value)
            })
            .disposed(by: disposeBag)
        
        self.addImageButton.rx.tap
            .bind(to: self.viewModel.addImageButtonTap)
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
                if selectedImageUUID == "nil" { return }
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
                        
                        if pin.pin.productInfo == nil {
                            self.viewModel.modifyPinOptionButtonTap.onNext(pin.UUID)
                        }
                        
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
        
        self.viewModel.sholudDrawCategory
            .drive(onNext: {[weak self] categorys in
                guard let self = self else { return }
                var categoryName : [String] = []
                var categoryId : [Int] = []
                
                for category in categorys.categories {
                    for subCategory in category.subCategories {
                        categoryName.append(subCategory.name)
                        categoryId.append(Int(subCategory.id))
                    }
                }
                
                self.categoryMultiView.setTag(words: categoryName, id: categoryId)
                let buttons = self.categoryMultiView.getButtons()
                
                for button in buttons {
                    button.rx.tap
                        .map { button.tag }
                        .bind(to: viewModel.subCategoryButtonTap)
                        .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.subCategories
            .subscribe(onNext: {[weak self] id in
                guard let self = self else { return }
                
                let buttons = self.categoryMultiView.getButtons()
                
                for button in buttons {
                    if button.tag == id {
                        let title = button.attributedTitle(for: .normal)!.string
                        button.backgroundColor = AppColor.primary.color
                        button.setAttributedTitle(NSAttributedString(string: title, attributes: Typography.body14SemiBold(color: AppColor.white).attributes), for: .normal)
                        button.layer.borderColor = AppColor.primary.color.cgColor
                    } else {
                        let title = button.attributedTitle(for: .normal)!.string
                        button.backgroundColor = AppColor.white.color
                        button.setAttributedTitle(NSAttributedString(string: title, attributes: Typography.body14Medium(color: AppColor.neutral700).attributes), for: .normal)
                        button.layer.borderColor = AppColor.neutral200.color.cgColor
                    }
                }
                
                if self.viewModel.postImageRelay.value.count != 0 && self.viewModel.subCategories.value != 0 && self.viewModel.contentRelay.value != ""{
                    self.completeButton.backgroundColor = AppColor.primary.color
                    self.completeButton.setAttributedTitle(NSAttributedString(string : "등록하기", attributes: Typography.body15SemiBold(color: AppColor.white).attributes), for: .normal)
                    self.completeButton.isEnabled = true
                } else {
                    self.completeButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        //MARK: NavBar
        self.backButton.rx.tap
            .bind(to: self.viewModel.backButtontap)
            .disposed(by: disposeBag)
        
        self.completeButton.rx.tap
            .bind(to: self.viewModel.saveButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.dismissVC
            .drive(onNext: {[weak self] _ in
                guard let tabBarController = self?.tabBarController else { return }
                tabBarController.tabBar.isHidden = false
                tabBarController.selectedIndex = 0
            })
            .disposed(by: disposeBag)
        
        self.viewModel.backToTabBar
            .drive(onNext: {[weak self] _ in
                guard let tabBarController = self?.tabBarController else { return }
                tabBarController.tabBar.isHidden = false
                tabBarController.selectedIndex = 0
            })
            .disposed(by: disposeBag)
        
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
        ])
        
        //MARK: SelectedImage
        NSLayoutConstraint.activate([
            selectedImageScrollView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            selectedImageScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            selectedImageScrollView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            selectedImageScrollView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            selectedImageScrollView.heightAnchor.constraint(equalTo: mainScrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            selectedImageStackView.topAnchor.constraint(equalTo: selectedImageScrollView.topAnchor),
            selectedImageStackView.leadingAnchor.constraint(equalTo: selectedImageScrollView.leadingAnchor),
            selectedImageStackView.trailingAnchor.constraint(equalTo: selectedImageScrollView.trailingAnchor),
            selectedImageStackView.bottomAnchor.constraint(equalTo: selectedImageScrollView.bottomAnchor),
            selectedImageStackView.heightAnchor.constraint(equalTo: selectedImageScrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageContainView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            imageContainView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            imageContainView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            imageScrollview.topAnchor.constraint(equalTo: imageContainView.topAnchor),
            imageScrollview.leadingAnchor.constraint(equalTo: imageContainView.leadingAnchor, constant: 20),
            imageScrollview.trailingAnchor.constraint(equalTo: imageContainView.trailingAnchor),
            imageScrollview.heightAnchor.constraint(equalToConstant: (view.frame.size.width - 20) / (4.5))
        ])
        
        NSLayoutConstraint.activate([
            imageScrollStackView.topAnchor.constraint(equalTo: imageScrollview.topAnchor),
            imageScrollStackView.leadingAnchor.constraint(equalTo: imageScrollview.leadingAnchor),
            imageScrollStackView.trailingAnchor.constraint(equalTo: imageScrollview.trailingAnchor),
            imageScrollStackView.bottomAnchor.constraint(equalTo: imageScrollview.bottomAnchor),
            imageScrollStackView.heightAnchor.constraint(equalTo: imageScrollview.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        NSLayoutConstraint.activate([
            buttonView.heightAnchor.constraint(equalToConstant: 85),
            buttonView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 24),
            buttonStack.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            addPinButton.heightAnchor.constraint(equalToConstant: 37),
            addPinButton.widthAnchor.constraint(equalToConstant: 72),
            autoPinAddButton.heightAnchor.constraint(equalToConstant: 37),
            autoPinAddButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 144)
        ])

        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentTextView.heightAnchor.constraint(equalToConstant: 112)
        ])
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: contentTextView.topAnchor, constant: 14),
            placeHolderLabel.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            categoryView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: categoryView.topAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 20),
            
            categoryMultiView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            categoryMultiView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 20),
            categoryMultiView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: -20),
            categoryMultiView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            completeButtonView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            completeButtonView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            completeButtonView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: completeButtonView.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: completeButtonView.trailingAnchor, constant: -20),
            completeButton.topAnchor.constraint(equalTo: completeButtonView.topAnchor, constant: 56),
            completeButton.bottomAnchor.constraint(equalTo: completeButtonView.bottomAnchor, constant: -10)
        ])
    }
    
    private var mainScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var mainStackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private var emptyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.neutral50.color
        return view
    }()
    
    private var imageContainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        stackView.backgroundColor = AppColor.neutral100.color
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var buttonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        button.setAttributedTitle(NSAttributedString(string: "핀 추가", attributes: Typography.body14SemiBold(color: AppColor.neutral900).attributes), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = AppColor.secondary.color
        button.layer.cornerRadius = 17.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var autoPinAddButton : UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "핀 자동 생성", attributes: Typography.body14SemiBold(color: AppColor.neutral900).attributes), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = AppColor.secondary.color
        button.layer.cornerRadius = 17.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var contentTextView : UITextView = {
        let textView = UITextView()
        textView.keyboardType = .default
        textView.returnKeyType = .done
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = AppColor.neutral200.color.cgColor
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 16, bottom: 14, right: 16)
        return textView
    }()
    
    private var placeHolderLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string : "최대 2000자 까지 작성할 수 있어요.\n해시태그는 20개 까지 추가할 수 있어요.", attributes: Typography.body14Medium(color: AppColor.neutral300).attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        button.setImage(AppImage.addImageButton.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColor.neutral100.color
        button.layer.cornerRadius = 8
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private var contentLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "내용 입력", attributes: Typography.subTitle16Bold(color: AppColor.neutral900).attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()
    
    private var categoryView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var categoryLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "카테고리 선택", attributes: Typography.subTitle16Bold(color: AppColor.neutral900).attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var categoryMultiView = MultiLineTagView(horizontalSpacing: 8, verticalSpacing: 8, rowHeight: 30, horizontalPadding: 10)
    
    private var completeButtonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var completeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColor.neutral50.color
        button.setAttributedTitle(NSAttributedString(string : "등록하기", attributes: Typography.body15SemiBold(color: AppColor.neutral300).attributes), for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    let navTitle : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "새 게시물", attributes: Typography.heading18Bold(color: AppColor.neutral900).attributes)
        return label
    }()
    
    let basicView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.neutral50.color
        return view
    }()
    
    let addImageButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColor.neutral700.color
        button.setAttributedTitle(NSAttributedString(string: "이미지 올리기", attributes: Typography.body15SemiBold(color: AppColor.white).attributes), for: .normal)
        button.layer.cornerRadius = 23.5
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
    
    func drawImage(_ imageInfo : PostImageStruct) {
        let view : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = AppColor.neutral50.color
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
            imageView.load(url: URL(string: imageInfo.imageUrl)!)
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
        imageScrollStackView.addArrangedSubview(view)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalTo: imageScrollview.heightAnchor),
            view.widthAnchor.constraint(equalTo: imageScrollview.heightAnchor),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }
    
    private func drawSelectedView(for imageInfo: PostImageStruct) {
        let selectedImageAndPin: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = AppColor.neutral50.color
            return view
        }()
        
        let selectedImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.load(url: URL(string: imageInfo.imageUrl)!) {[weak self] _ in
                self?.calcurateXY()
            }
            imageView.uuidString = imageInfo.UUID // Use hash value as a tag to identify
            return imageView
        }()
        
        selectedImageAndPin.addSubview(selectedImageView)
        selectedImageStackView.addArrangedSubview(selectedImageAndPin)
        
        NSLayoutConstraint.activate([
            selectedImageAndPin.widthAnchor.constraint(equalTo: selectedImageScrollView.widthAnchor),
            selectedImageAndPin.heightAnchor.constraint(equalTo: selectedImageScrollView.heightAnchor),
            
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
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
}
