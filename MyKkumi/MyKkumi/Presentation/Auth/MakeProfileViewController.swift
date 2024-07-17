//
//  MakeProfileViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/15/24.
//

import Foundation
import UIKit
import RxSwift

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
        mainStack.addArrangedSubview(completeButton)
        mainStack.addArrangedSubview(nickNameStack)
        mainStack.addArrangedSubview(profileImage)
        
        nickNameStack.addArrangedSubview(nickNameInfoButton)
        nickNameStack.addArrangedSubview(nickNameLabel)
        nickNameStack.addArrangedSubview(nickNameTextField)
    }
    
    public override func setupBind(viewModel: MakeProfileViewModelProtocol) {
        self.viewModel = viewModel
        
    }
    
    public override func setupViewProperty() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        nickNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
    }
    
    public override func setupLayout() {

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
        textField.underline(viewSize: 1, color: .black)
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
        return button
    }()
}
