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
        view.addSubview(pleaseWriteNickname)
        view.addSubview(profileLabel)
        view.addSubview(profileImage)
        view.addSubview(profileImageChangeButton)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameView)
        view.addSubview(conditionFistView)
        view.addSubview(conditionSecondView)
        view.addSubview(completeButton)
        
        conditionFistView.addSubview(firstElliipse)
        conditionFistView.addSubview(firstConditionLabel)
        conditionSecondView.addSubview(SecondElliipse)
        conditionSecondView.addSubview(secondConditionLabel)
        
        nickNameView.addSubview(nickNameTextField)
        nickNameView.addSubview(nickNameCancelButton)
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
                let profileImageUrl = viewModel.imageUrl.value
                let categoryList = viewModel.categoryList.value
                return PatchUserVO(nickname: nickName, introduction: nil, profilImage: profileImageUrl, categoryIds: categoryList)
            }
            .bind(to: viewModel.completeButtonTap)
            .disposed(by: disposeBag)
        
        self.profileImageChangeButton.rx.tap
            .bind(to: self.viewModel.profileImageTap)
            .disposed(by: disposeBag)
        
        self.nickNameTextField.rx.text.orEmpty
            .bind(to: self.viewModel.nickNameInput)
            .disposed(by: disposeBag)
        
        self.viewModel.nickName
            .subscribe(onNext : {[weak self] nickname in
                guard let self = self else { return }
                if nickname == "" || nickname!.count < 3 || nickname!.count > 16 {
                    if nickname!.count > 16 {
                        self.nickNameTextField.isEnabled = false
                    } else {
                        self.nickNameTextField.isEnabled = true
                    }
                    completeButton.backgroundColor = AppColor.neutral50.color
                    completeButton.isEnabled = false
                    let attributedString = NSMutableAttributedString(string : "완료", attributes: Typography.body15SemiBold(color: AppColor.neutral900).attributes)
                    attributedString.addAttribute(.foregroundColor, value: AppColor.neutral300.color, range: NSRange(location: 0, length: attributedString.length))
                    completeButton.setAttributedTitle(attributedString, for: .normal)
                } else {
                    completeButton.backgroundColor = AppColor.primary.color
                    completeButton.isEnabled = true
                    let attributedString = NSMutableAttributedString(string : "완료", attributes: Typography.body15SemiBold(color: AppColor.neutral900).attributes)
                    attributedString.addAttribute(.foregroundColor, value: AppColor.white.color, range: NSRange(location: 0, length: attributedString.length))
                    completeButton.setAttributedTitle(attributedString, for: .normal)
                }
            })
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
        
        self.nickNameCancelButton.rx.tap
            .bind(to: self.viewModel.deleteButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.deleteTextField
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.nickNameTextField.text = ""
                self.viewModel.nickName.accept("")
            })
            .disposed(by: disposeBag)
    }
    
    public override func setupViewProperty() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
    }
    
    public override func setupLayout() {
        NSLayoutConstraint.activate([
            pleaseWriteNickname.topAnchor.constraint(equalTo: view.topAnchor, constant: 84),
            pleaseWriteNickname.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        //MARK: profile
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: pleaseWriteNickname.bottomAnchor, constant: 40),
            profileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 12),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 88),
            profileImage.widthAnchor.constraint(equalToConstant: 88)
        ])
        
        NSLayoutConstraint.activate([
            profileImageChangeButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            profileImageChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageChangeButton.heightAnchor.constraint(equalToConstant: 44),
            profileImageChangeButton.widthAnchor.constraint(equalToConstant: 136)
        ])
        
        //MARK: nickname
        NSLayoutConstraint.activate([
            nickNameLabel.topAnchor.constraint(equalTo: profileImageChangeButton.bottomAnchor, constant: 40),
            nickNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            nickNameView.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 12),
            nickNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nickNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nickNameView.heightAnchor.constraint(equalToConstant: 49)
        ])
        
        NSLayoutConstraint.activate([
            nickNameTextField.topAnchor.constraint(equalTo: nickNameView.topAnchor),
            nickNameTextField.leadingAnchor.constraint(equalTo: nickNameView.leadingAnchor, constant: 16),
            nickNameTextField.trailingAnchor.constraint(equalTo: nickNameView.trailingAnchor),
            nickNameTextField.bottomAnchor.constraint(equalTo: nickNameView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nickNameCancelButton.topAnchor.constraint(equalTo: nickNameView.topAnchor, constant: 12),
            nickNameCancelButton.trailingAnchor.constraint(equalTo: nickNameView.trailingAnchor, constant: -13),
            nickNameCancelButton.heightAnchor.constraint(equalToConstant: 24),
            nickNameCancelButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            conditionFistView.topAnchor.constraint(equalTo: nickNameView.bottomAnchor, constant: 12),
            conditionFistView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            conditionFistView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            conditionFistView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        NSLayoutConstraint.activate([
            firstElliipse.leadingAnchor.constraint(equalTo: conditionFistView.leadingAnchor),
            firstElliipse.centerYAnchor.constraint(equalTo: conditionFistView.centerYAnchor),
            firstElliipse.heightAnchor.constraint(equalToConstant: 4),
            firstElliipse.widthAnchor.constraint(equalToConstant: 4),
        ])
        
        NSLayoutConstraint.activate([
            firstConditionLabel.leadingAnchor.constraint(equalTo: firstElliipse.trailingAnchor, constant: 7)
        ])
        
        NSLayoutConstraint.activate([
            conditionSecondView.topAnchor.constraint(equalTo: conditionFistView.bottomAnchor),
            conditionSecondView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            conditionSecondView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            conditionSecondView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        NSLayoutConstraint.activate([
            SecondElliipse.leadingAnchor.constraint(equalTo: conditionSecondView.leadingAnchor),
            SecondElliipse.centerYAnchor.constraint(equalTo: conditionSecondView.centerYAnchor),
            SecondElliipse.heightAnchor.constraint(equalToConstant: 4),
            SecondElliipse.widthAnchor.constraint(equalToConstant: 4),
        ])
        
        NSLayoutConstraint.activate([
            secondConditionLabel.leadingAnchor.constraint(equalTo: SecondElliipse.trailingAnchor, constant: 7)
        ])
        
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
    }
    
    private var pleaseWriteNickname : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: "마이꾸미에 사용하실\n닉네임을 작성해주세요", attributes: Typography.heading20Bold(color: AppColor.neutral900).attributes)
        label.textColor = AppColor.neutral900.color
        return label
    }()
    
    private var profileLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "프로필 사진", attributes: Typography.body15SemiBold(color: AppColor.neutral900).attributes)
        label.textColor = AppColor.neutral900.color
        return label
    }()
    
    private var profileImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = AppImage.profile.image
        image.layer.cornerRadius = image.frame.width / 2
        image.clipsToBounds = true
        return image
    }()
    
    private var profileImageChangeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "프로필 이미지 변경", attributes: Typography.body13SemiBold(color: AppColor.neutral900).attributes), for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = AppColor.secondary.color
        return button
    }()
    
    private var nickNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "닉네임", attributes: Typography.body15SemiBold(color: AppColor.neutral900).attributes)
        label.textColor = AppColor.neutral900.color
        return label
    }()
    
    private var nickNameView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.neutral200.color.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임을 작성해주세요", attributes: Typography.body14Medium(color: AppColor.neutral900).attributes)
        return textField
    }()
    
    private var nickNameCancelButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(AppImage.cancel.image, for: .normal)
        return button
    }()
    
    private var conditionFistView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var firstElliipse : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = AppImage.ellipse.image
        return image
    }()

    private var firstConditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // NSMutableAttributedString을 사용하여 텍스트 색상을 포함한 속성 추가
        let attributes = Typography.caption12Medium(color: AppColor.neutral900).attributes
        var attributedString = NSMutableAttributedString(string: "한글/영문/숫자/특수문자 모두 가능해요", attributes: attributes)
        
        // 텍스트 색상 추가
        attributedString.addAttribute(.foregroundColor, value: AppColor.neutral300.color, range: NSRange(location: 0, length: attributedString.length))
        
        label.attributedText = attributedString
        return label
    }()
    
    private var conditionSecondView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var SecondElliipse : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = AppImage.ellipse.image
        return image
    }()

    private var secondConditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // NSMutableAttributedString을 사용하여 텍스트 색상을 포함한 속성 추가
        let attributes = Typography.caption12Medium(color: AppColor.neutral900).attributes
        var attributedString = NSMutableAttributedString(string: "최소 3자 ~ 최대 16자로 적어주세요", attributes: attributes)
        
        // 텍스트 색상 추가
        attributedString.addAttribute(.foregroundColor, value: AppColor.neutral300.color, range: NSRange(location: 0, length: attributedString.length))
        
        label.attributedText = attributedString
        return label
    }()
    
    private var completeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string : "완료", attributes: Typography.body15SemiBold(color: AppColor.neutral900).attributes)
        attributedString.addAttribute(.foregroundColor, value: AppColor.neutral300, range: NSRange(location: 0, length: attributedString.length))
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = AppColor.neutral50.color
        button.layer.cornerRadius = 12
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
