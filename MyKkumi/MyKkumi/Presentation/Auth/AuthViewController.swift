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
        self.navigationController?.isNavigationBarHidden = false
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        <#code#>
//    }
    
    public override func setupHierarchy() {
        view.addSubview(authLabel)
        view.addSubview(authImage)
        view.addSubview(kakaoButton)
        view.addSubview(kakaoView)
        view.addSubview(appleButton)
        view.addSubview(appleView)
        appleView.addSubview(appleLogo)
        appleView.addSubview(appleLabel)
        kakaoView.addSubview(kakaoLabel)
        kakaoView.addSubview(kakaoSimbol)
        
        view.bringSubviewToFront(appleLogo)
        appleView.bringSubviewToFront(appleLabel)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
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
                } else {
                    viewModel.backButtonTap.onNext(Void())
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
                } else {
                    viewModel.backButtonTap.onNext(())
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
            kakaoButton.topAnchor.constraint(equalTo: authImage.bottomAnchor, constant: 80),
            kakaoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            kakaoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            kakaoButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            kakaoView.topAnchor.constraint(equalTo: kakaoButton.topAnchor, constant: 16),
            kakaoView.centerXAnchor.constraint(equalTo: kakaoButton.centerXAnchor),
            kakaoView.widthAnchor.constraint(equalToConstant: 121.5)
        ])
        
        NSLayoutConstraint.activate([
            kakaoSimbol.leadingAnchor.constraint(equalTo: kakaoView.leadingAnchor),
            kakaoSimbol.heightAnchor.constraint(equalToConstant: 20),
            kakaoSimbol.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            kakaoLabel.leadingAnchor.constraint(equalTo: kakaoSimbol.trailingAnchor, constant: 8),
            kakaoLabel.centerYAnchor.constraint(equalTo: kakaoSimbol.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            appleButton.topAnchor.constraint(equalTo: kakaoButton.bottomAnchor, constant: 16),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            appleButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            appleView.topAnchor.constraint(equalTo: appleButton.topAnchor, constant: 16),
            appleView.centerXAnchor.constraint(equalTo: appleButton.centerXAnchor),
            appleView.widthAnchor.constraint(equalToConstant: 121.5)
        ])
        
        NSLayoutConstraint.activate([
            appleLogo.leadingAnchor.constraint(equalTo: appleView.leadingAnchor),
            appleLogo.heightAnchor.constraint(equalToConstant: 19),
            appleLogo.widthAnchor.constraint(equalToConstant: 15)
        ])
        
        NSLayoutConstraint.activate([
            appleLabel.leadingAnchor.constraint(equalTo: appleLogo.trailingAnchor, constant: 10.5),
            appleLabel.centerYAnchor.constraint(equalTo: appleLogo.centerYAnchor)
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

        var attributes = Typography.gmarketSansBold(color: AppColor.neutral900).attributes
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
    
    private var kakaoView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.attributedText = NSAttributedString(string:"카카오로 로그인", attributes: Typography.body15SemiBold(color: AppColor.neutral900).attributes)
        return label
    }()
    
    private var kakaoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColor.kakao.color
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var appleView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.black.color
        return view
    }()
    
    private var appleLogo : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = AppImage.appleLogo.image
        return image
    }()
    
    private var appleLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Apple로 로그인", attributes: Typography.body15SemiBold(color: AppColor.white).attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var appleButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = AppColor.black.color
        return button
    }()
    
    private var backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(AppImage.backArrow.image , for: .normal)
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
