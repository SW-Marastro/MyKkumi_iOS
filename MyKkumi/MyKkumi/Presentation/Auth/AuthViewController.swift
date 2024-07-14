//
//  AuthViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/10/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

class AuthViewController : BaseViewController<AuthViewModelProtocol>{
    var viewModel: AuthViewModelProtocol!
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupHierarchy() {
        view.addSubview(mainStack)
        mainStack.addSubview(kakaoButton)
        mainStack.addSubview(appleButton)
    }
    
    public override func setupBind(viewModel: AuthViewModelProtocol){
        self.viewModel = viewModel
        
        self.kakaoButton.rx.tap
            .bind(to: viewModel.appleButtonTap)
            .disposed(by: disposeBag)
        
        self.appleButton.rx.controlEvent(.touchUpInside)
            .bind(to: viewModel.appleButtonTap)
            .disposed(by: disposeBag)
    }
    
    public override func setupLayout() {
        //MainStack
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        //AppleButton
        appleButton.center = view.center
        NSLayoutConstraint.activate([
            appleButton.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 33),
            appleButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -33)
        ])
        
        NSLayoutConstraint.activate([
            kakaoButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 11),
            kakaoButton.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 33),
            kakaoButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -33)
        ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private var mainStack : UIStackView  = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var kakaoButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오 로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var appleButton : ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 10
        return button
    }()
}
