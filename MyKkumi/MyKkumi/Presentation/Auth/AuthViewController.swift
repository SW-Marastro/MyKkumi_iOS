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
        self.navigationController?.isNavigationBarHidden = true
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        <#code#>
//    }
    
    public override func setupHierarchy() {
        view.addSubview(customNavBar)
        view.addSubview(authLabel)
        view.addSubview(authImage)
        view.addSubview(kakaoBackGroundView)
        view.addSubview(appleButton)
        customNavBar.addSubview(backButton)
        kakaoBackGroundView.addSubview(kakaoButton)
        kakaoBackGroundView.addSubview(kakaoLabel)
        kakaoBackGroundView.addSubview(kakaoSimbol)
        
        kakaoBackGroundView.bringSubviewToFront(kakaoButton)
    }
    
    public override func setupBind(viewModel: AuthViewModelProtocol){
        self.viewModel = viewModel
        
        self.kakaoButton.rx.tap
            .bind(to: viewModel.kakaoButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.kakaoSuccess
            .drive(onNext : {result in
                if result {
                    let collectCategoryVC = CollectCategoryViewController()
                    collectCategoryVC.setupBind(viewModel: CollectCategoryViewModel())
                    self.navigationController?.pushViewController(collectCategoryVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        self.appleButton.rx.controlEvent(.touchUpInside)
            .bind(to: viewModel.appleButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.startAppleSignInFlow
            .drive(onNext : { _ in
                self.startSignInWithAppleFlow()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.appleSuccess
            .drive(onNext : {result in
                if result {
                    let collectCategoryVC = CollectCategoryViewController()
                    collectCategoryVC.setupBind(viewModel: CollectCategoryViewModel())
                    self.navigationController?.pushViewController(collectCategoryVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        self.backButton.rx.tap
            .bind(to: viewModel.backButtonTap)
            .disposed(by: disposeBag)
    }
    
    private func startSignInWithAppleFlow() {
       let request = ASAuthorizationAppleIDProvider().createRequest()
       request.requestedScopes = [.fullName, .email]
       
       let authorizationController = ASAuthorizationController(authorizationRequests: [request])
       authorizationController.delegate = self
       authorizationController.presentationContextProvider = self
       authorizationController.performRequests()
    }
    
    public override func setupLayout() {
        
        NSLayoutConstraint.activate([
            authLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160),
            authLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            authImage.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: 12),
            authImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authImage.widthAnchor.constraint(equalToConstant: 160),
            authImage.heightAnchor.constraint(equalToConstant: 188)
        ])
        
        //MARK: LoginButton
        NSLayoutConstraint.activate([
            kakaoBackGroundView.topAnchor.constraint(equalTo: authImage.bottomAnchor, constant: 80),
            kakaoBackGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            kakaoBackGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            kakaoBackGroundView.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            kakaoSimbol.topAnchor.constraint(equalTo: kakaoBackGroundView.topAnchor, constant: 15),
            kakaoSimbol.leadingAnchor.constraint(equalTo: kakaoBackGroundView.leadingAnchor, constant: 16),
            kakaoSimbol.widthAnchor.constraint(equalToConstant: 24),
            kakaoSimbol.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            kakaoLabel.topAnchor.constraint(equalTo: kakaoBackGroundView.topAnchor, constant: 15),
            kakaoLabel.centerXAnchor.constraint(equalTo: kakaoBackGroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            kakaoButton.leadingAnchor.constraint(equalTo: kakaoBackGroundView.leadingAnchor),
            kakaoButton.topAnchor.constraint(equalTo: kakaoBackGroundView.topAnchor),
            kakaoButton.bottomAnchor.constraint(equalTo: kakaoBackGroundView.bottomAnchor),
            kakaoButton.trailingAnchor.constraint(equalTo: kakaoBackGroundView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            kakaoBackGroundView.topAnchor.constraint(equalTo: authImage.bottomAnchor, constant: 80),
            kakaoBackGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            kakaoBackGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            kakaoBackGroundView.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            appleButton.topAnchor.constraint(equalTo: kakaoButton.bottomAnchor, constant: 16),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            appleButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 14),
            backButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 15),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor)
        ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private var authLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center  // 전체 레이블의 텍스트 정렬을 중앙으로 설정
        label.numberOfLines = 0

        // NSAttributedString 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center  // NSAttributedString의 텍스트 정렬을 중앙으로 설정
        paragraphStyle.lineHeightMultiple = 1.4

        var attributes = Typography.gmarketSansBold.attributes
        attributes[.paragraphStyle] = paragraphStyle  // paragraphStyle 속성을 추가

        let attributedString = NSAttributedString(string: "취미생활 꿀템이 궁금하다면\n마이꾸미에서!", attributes: attributes)
        label.attributedText = attributedString
        label.textColor = AppColor.primary.color
        return label
    }()

    
    private var authImage : UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = AppImage.launch.image
        return image
    }()
    
    private var kakaoBackGroundView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.kakao.color
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var kakaoSimbol : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = AppImage.kakaoSimbol.image
        return image
    }()
    
    private var kakaoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string:"카카오 ID로 로그인", attributes: Typography.body15SemiBold.attributes)
        return label
    }()
    
    private var kakaoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var appleButton : ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 10
        return button
    }()
    
    private var customNavBar : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()
}

extension AuthViewController : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let userIdentifier = appleIDCredential.authorizationCode {
                // ViewModel에 인증 결과 전달
                viewModel.appleUserData
                    .onNext(String(data: userIdentifier, encoding: .utf8) ?? "")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // ViewModel에 인증 오류 전달
        viewModel.appleAuthError
            .onNext(error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
