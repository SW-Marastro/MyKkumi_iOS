//
//  MakeProfileViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/15/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MakeProfileViewController : BaseViewController<MakeProfileViewModelProtocol> {
    var viewModel : MakeProfileViewModelProtocol!
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupHierarchy() {
        view.addSubview(mainStack)
        mainStack.addSubview(profileImage)
        mainStack.addSubview(nickNameStack)
        mainStack.addSubview(completeButton)
        
        nickNameStack.addSubview(nickNameInfoButton)
        nickNameStack.addSubview(nickNameLabel)
        nickNameStack.addSubview(nickNameTextField)
    }
    
    public override func setupDelegate() {
        nickNameTextField.keyboardType = .default
        nickNameTextField.returnKeyType = .done
        nickNameTextField.isUserInteractionEnabled = true
        nickNameTextField.delegate = self
    }
    
    public override func setupBind(viewModel: MakeProfileViewModelProtocol) {
        self.viewModel = viewModel
        
        self.completeButton.rx.tap
            .map {_ in
                let nickName = viewModel.nickName.value
                let profileImage = viewModel.imageData.value
                return PatchUserVO(nickname: nickName, introduction: nil, profilImage: nil, categoryIds: nil)
            }
            .bind(to: viewModel.completeButtonTap)
            .disposed(by: disposeBag)
        
        self.profileImage.rx.tapGesture
            .map{_ in}
            .bind(to: self.viewModel.profileImageTap)
            .disposed(by: disposeBag)
        
        self.nickNameTextField.rx.text.orEmpty
            .bind(to: self.viewModel.nickName)
            .disposed(by: disposeBag)
        
        self.viewModel.sholudPopView
            .drive(onNext : { _ in
                NotificationCenter.default.post(name : .deleteAuth, object: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.sholudPushSelectAlert
            .drive(onNext : {[weak self] _ in
                let alert = UIAlertController(title : "프로필 사진 설정", message: "", preferredStyle: .actionSheet)
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
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
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
    }
    
    public override func setupViewProperty() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        nickNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
    }
    
    public override func setupLayout() {
        //mainStack
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        //completButton
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: -48),
            completeButton.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 16),
            completeButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant : -16)
        ])
        
        //profileImage
        NSLayoutConstraint.activate([
            profileImage.centerYAnchor.constraint(equalTo: mainStack.centerYAnchor),
            profileImage.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 200),
            profileImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        //nickNameStack
        NSLayoutConstraint.activate([
            nickNameStack.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            nickNameStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 16),
            nickNameStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -16)
        ])
        
        //nickNameInfoButton
        NSLayoutConstraint.activate([
            nickNameInfoButton.widthAnchor.constraint(equalTo: nickNameLabel.heightAnchor),
            nickNameInfoButton.heightAnchor.constraint(equalTo: nickNameLabel.heightAnchor),
            nickNameInfoButton.leadingAnchor.constraint(equalTo: nickNameStack.leadingAnchor)
        ])
        
        //nickNameLabel
        NSLayoutConstraint.activate([
            nickNameLabel.leadingAnchor.constraint(equalTo: nickNameInfoButton.trailingAnchor, constant: 8),
        ])
        
        //nickNameTextField
        NSLayoutConstraint.activate([
            nickNameTextField.leadingAnchor.constraint(equalTo: nickNameLabel.trailingAnchor, constant: 8),
            nickNameTextField.trailingAnchor.constraint(equalTo: nickNameStack.trailingAnchor),
            nickNameTextField.heightAnchor.constraint(equalTo: nickNameLabel.heightAnchor),
        ])
    }
    
    private var mainStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private var nickNameStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    //✅ TODO: 버튼 홀드 RX연결 위한 과정 필요함
    private var nickNameInfoButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "InfoCircle"), for: .normal)
        return button
    }()
    
    private var nickNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "닉네임"
        return label
    }()
    
    private var nickNameTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "닉네임을 입력하세요"
        return textField
    }()
    
    private var profileImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ProfileImage")
        return image
    }()
    
    private var completeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("완료", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        return button
    }()
}

extension MakeProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImage.image = selectedImage
            viewModel.imageData.accept(selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
