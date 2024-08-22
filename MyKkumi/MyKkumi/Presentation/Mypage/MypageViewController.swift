//
//  MypageViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import RxSwift
import UIKit
import SafariServices

class MypageViewController : BaseViewController<MypageViewModelProtocol> {
    var viewModel : MypageViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupHierarchy() {
        view.addSubview(logoImage)
        view.addSubview(logoutButton)
        view.addSubview(deleteIdButton)
    }
    
    override func setupBind(viewModel: MypageViewModelProtocol) {
        self.viewModel = viewModel
        
        self.logoutButton.rx.tap
            .bind(to: self.viewModel.logoutButtonTap)
            .disposed(by: disposeBag)
        
        self.deleteIdButton.rx.tap
            .bind(to: self.viewModel.deleteIdButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.sholudAlertDeleteComplet
            .drive(onNext: {[weak self] title in
                guard let self = self else { return }
                
                let alert = UIAlertController(title : title, message: "", preferredStyle: .alert)
                let complete = UIAlertAction(title: "완료", style: .default)
                
                alert.addAction(complete)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.sholudAlertLogout
            .drive(onNext: {[weak self] title in
                guard let self = self else { return }
                
                let alert = UIAlertController(title : title, message: "", preferredStyle: .alert)
                let complete = UIAlertAction(title: "완료", style: .default)
                
                alert.addAction(complete)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.sholudPresentForm
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let formUrl = NSURL(string: "https://forms.gle/Jgh7U3cujjfLcbwm7")!
                let formSafariView : SFSafariViewController = SFSafariViewController(url: formUrl as URL)
                
                self.present(formSafariView, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 160),
            logoImage.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 12),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            logoutButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            deleteIdButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            deleteIdButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 10),
            deleteIdButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            deleteIdButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            deleteIdButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    private let logoImage : UIImageView = {
        let image = UIImageView()
        image.image = AppImage.whiteAppLogo.image
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let logoutButton : UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "로그아웃", attributes: Typography.body14SemiBold(color: AppColor.white).attributes), for: .normal)
        button.backgroundColor = AppColor.primary.color
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteIdButton : UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "회원탈퇴", attributes: Typography.body14SemiBold(color: AppColor.white).attributes), for: .normal)
        button.backgroundColor = AppColor.primary.color
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
