//
//  SetProfilViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 11/21/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseAnalytics

class SetProfilViewController : BaseViewController<SetProfilViewModelProtocol> {
    var viewmodel : SetProfilViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: LogEvnetParameter.SetProfilViewController.value,
            AnalyticsParameterScreenClass: NSStringFromClass(type(of: self))
        ])
    }
    
    override func setupHierarchy() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(profileImageLabel)
        mainStackView.addArrangedSubview(profileImage)
        mainStackView.addArrangedSubview(profileImageChangeButton)
        mainStackView.addArrangedSubview(nickNameLabel)
        mainStackView.addArrangedSubview(nickNameView)
        mainStackView.addArrangedSubview(conditionFistView)
        mainStackView.addArrangedSubview(conditionSecondView)
        mainStackView.addArrangedSubview(emailLabel)
        mainStackView.addArrangedSubview(emailView)
        mainStackView.addArrangedSubview(introdutionLabel)
        mainStackView.addArrangedSubview(introdutionView)
        mainStackView.addArrangedSubview(categoryLabel)
        mainStackView.addArrangedSubview(categoryMultiView)
        
        nickNameView.addSubview(nickNameTextField)
        conditionFistView.addSubview(firstElliipse)
        conditionFistView.addSubview(firstConditionLabel)
        conditionSecondView.addSubview(SecondElliipse)
        conditionSecondView.addSubview(secondConditionLabel)
        
        emailView.addSubview(emailViewLabel)
        introdutionView.addSubview(introdutionTextField)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.titleView = profilLabel
    }
    
    override public func setupBind(viewModel: SetProfilViewModelProtocol) {
        self.viewmodel = viewModel
    }
    
    override func setupLayout() {
        
    }
    
    private var mainScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        return scrollView
    }()
    
    private var mainStackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private var backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(AppImage.backArrow.image, for: .normal)
        return button
    }()
    
    private var profilLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "프로필 수정"
        label.font = Typography.heading18Bold(color: AppColor.neutral900).font()
        return label
    }()
    
    private var profileImageLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "프로필 사진"
        label.font = Typography.body15Medium(color: AppColor.neutral900).font()
        return label
    }()
    
    private var profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = AppImage.profile.image
        return imageView
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
    
    private var emailLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "이메일", attributes: Typography.body15SemiBold(color: AppColor.neutral900).attributes)
        label.textColor = AppColor.neutral900.color
        return label
    }()
    
    private var emailView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.neutral200.color.cgColor
        view.backgroundColor = AppColor.neutral50.color
        view.layer.masksToBounds = true
        return view
    }()
    
    private var emailViewLabel: UILabel = {
        let textField = UILabel()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = Typography.body14Medium(color: AppColor.neutral900).font()
        return textField
    }()
    
    private var introdutionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "한 줄 소개", attributes: Typography.body15SemiBold(color: AppColor.neutral900).attributes)
        label.textColor = AppColor.neutral900.color
        return label
    }()
    
    private var introdutionView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.neutral200.color.cgColor
        view.backgroundColor = AppColor.neutral50.color
        view.layer.masksToBounds = true
        return view
    }()
    
    private var introdutionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "한 줄로 자신을 소개해보세요 (최대 50차)", attributes: Typography.body14Medium(color: AppColor.neutral400).attributes)
        return textField
    }()
    
    private var categoryLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "관심 취미", attributes: Typography.subTitle16Bold(color: AppColor.neutral900).attributes)
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
        button.setAttributedTitle(NSAttributedString(string : "수정완료", attributes: Typography.body15SemiBold(color: AppColor.neutral300).attributes), for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
}
