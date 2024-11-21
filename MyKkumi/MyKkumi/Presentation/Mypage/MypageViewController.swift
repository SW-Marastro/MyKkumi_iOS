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
import FirebaseAnalytics

class MypageViewController : BaseViewController<MypageViewModelProtocol> {
    var viewModel : MypageViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: LogEvnetParameter.MypageViewController.value,
            AnalyticsParameterScreenClass: NSStringFromClass(type(of: self))
        ])
    }
    
    override func setupHierarchy() {
        self.view.addSubview(userView)
        self.view.addSubview(notificationView)
        self.notificationView.addSubview(mykkumiLogo)
        self.notificationView.addSubview(notificationText)
    }
    
    override func setupBind(viewModel: MypageViewModelProtocol) {
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
        
        self.viewModel.showLoginedPage
            .drive(onNext : { [weak self] user in
                guard let self = self else {return}
                self.makeLoginedView(user: user)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.showUnloginedPage
            .drive(onNext : {[weak self] _ in
                guard let self = self else {return}
                self.makeUnloginedView()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.showAuthView
            .drive(onNext: {
                NotificationCenter.default.post(name: .showAuth, object: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            userView.topAnchor.constraint(equalTo: view.topAnchor),
            userView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            notificationView.topAnchor.constraint(equalTo: userView.bottomAnchor),
            notificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mykkumiLogo.centerXAnchor.constraint(equalTo: notificationView.centerXAnchor),
            mykkumiLogo.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            mykkumiLogo.heightAnchor.constraint(equalToConstant: 80),
            mykkumiLogo.widthAnchor.constraint(equalToConstant: 65)
        ])
        
        NSLayoutConstraint.activate([
            notificationText.topAnchor.constraint(equalTo: mykkumiLogo.bottomAnchor, constant: 15.54),
            notificationText.centerXAnchor.constraint(equalTo: notificationView.centerXAnchor)
        ])
    }
    
    private var notificationView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.white.color
        return view
    }()
    
    private var mykkumiLogo : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = AppImage.whiteAppLogo.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var notificationText : UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "더 많은 기능을 준비 중이에요!"
        textView.font = Typography.body14Medium(color: AppColor.neutral600).font()
        return textView
    }()
    
    private var userView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.neutral50.color
        return view
    }()
}

extension MypageViewController {
    func makeUnloginedView() {
        let loginButton : UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = AppColor.primary.color
            button.setAttributedTitle(NSAttributedString(string : "로그인하기", attributes: Typography.body15SemiBold(color: AppColor.white).attributes), for: .normal)
            button.layer.cornerRadius = 12
            return button
        }()
        
        let contentLabel : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.attributedText = NSAttributedString(string : "로그인 후 마이꾸미의 더 많은 서비스를\n이용할 수 있어요.", attributes: Typography.body15SemiBold(color: AppColor.neutral900).attributes)
            return label
        }()
        
        let loginLabel :UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "로그인하세요"
            label.font = Typography.heading20Bold(color: AppColor.neutral900).font()
            return label
        }()
        
        loginButton.rx.tap
            .bind(to: self.viewModel.tapLoginButton)
            .disposed(by: disposeBag)
        
        userView.addSubview(loginButton)
        userView.addSubview(contentLabel)
        userView.addSubview(loginLabel)
        
        NSLayoutConstraint.activate([
            userView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: userView.bottomAnchor, constant: -40),
            loginButton.leadingAnchor.constraint(equalTo: userView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: userView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -24),
            contentLabel.leadingAnchor.constraint(equalTo: userView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            loginLabel.bottomAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -24),
            loginLabel.leadingAnchor.constraint(equalTo: userView.leadingAnchor, constant: 20)
        ])
    }
    
    func makeLoginedView(user : UserVO) {
        let emptyView : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = AppColor.white.color
            view.layer.cornerRadius = 12
            return view
        }()
        
        let profilImage : UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            if let url = user.profilImage {
                imageView.load(url: URL(string: url)!)
            } else {
                imageView.image = AppImage.profile.image
            }
            return imageView
        }()
        
        let name : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = user.nickname ?? "이름을 설정해주세요"
            label.font = Typography.body15SemiBold(color: AppColor.neutral900).font()
            return label
        }()
        
        let content : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = user.introduction ?? "자신을 설명해주세요!"
            label.font = Typography.body13Medium(color: AppColor.neutral700).font()
            return label
        }()
        
        let setProfilButton : UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = AppColor.secondary.color
            button.layer.cornerRadius = 10
            button.setAttributedTitle(NSAttributedString(string : "프로필 수정", attributes: Typography.body13SemiBold(color: AppColor.neutral900).attributes), for: .normal)
            return button
        }()
        
        let profilLabel : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "프로필"
            label.font = Typography.heading20Bold(color: AppColor.neutral900).font()
            return label
        }()
        
        let settingButton  : UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setBackgroundImage(AppImage.settingButton.image, for: .normal)
            return button
        }()
        
        setProfilButton.rx.tap
            .bind(to: self.viewModel.tapProfilSettingButton)
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .bind(to: self.viewModel.tapSettingButton)
            .disposed(by: disposeBag)
        
        userView.addSubview(emptyView)
        userView.addSubview(profilLabel)
        userView.addSubview(settingButton)
        emptyView.addSubview(profilImage)
        emptyView.addSubview(name)
        emptyView.addSubview(content)
        emptyView.addSubview(setProfilButton)
        
        NSLayoutConstraint.activate([
            userView.heightAnchor.constraint(equalToConstant: 332)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.bottomAnchor.constraint(equalTo: userView.bottomAnchor, constant: -40),
            emptyView.leadingAnchor.constraint(equalTo: userView.leadingAnchor, constant: 20),
            emptyView.trailingAnchor.constraint(equalTo: userView.trailingAnchor, constant: -20),
            emptyView.heightAnchor.constraint(equalToConstant: 171)
        ])
        
        NSLayoutConstraint.activate([
            profilImage.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 20),
            profilImage.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            profilImage.heightAnchor.constraint(equalToConstant: 72),
            profilImage.widthAnchor.constraint(equalToConstant: 72)
        ])
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 34),
            name.leadingAnchor.constraint(equalTo: profilImage.trailingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 3),
            content.leadingAnchor.constraint(equalTo: profilImage.trailingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            setProfilButton.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -20),
            setProfilButton.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            setProfilButton.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20),
            setProfilButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            profilLabel.leadingAnchor.constraint(equalTo: userView.leadingAnchor, constant: 20),
            profilLabel.bottomAnchor.constraint(equalTo: emptyView.topAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            settingButton.trailingAnchor.constraint(equalTo: userView.trailingAnchor, constant: -22.4),
            settingButton.bottomAnchor.constraint(equalTo: emptyView.topAnchor, constant: -28.4),
            settingButton.heightAnchor.constraint(equalToConstant: 20),
            settingButton.widthAnchor.constraint(equalToConstant: 19.2)
        ])
    }
}
 
/*
 흐름
 일단 mypage 넘어 오면 -> mypageViewmodel에서 login 여부 확인
 -> 로그인 한 경우 보여야 하는 page -> 프로필 정보 page + 환경설정 버튼 -> 환경설정은 누르면 프로필 수정 -> 여기서 회원 탈퇴 할 수 있도록 만들어야함
 -> 로그인 하지 않은 경우 보여야 하는 page -> 로그인 유도 page
 -> 각각을 view로 만드는 함수 제작하고 전체를 stack으로 만들어서 보이도록 해야할듯
 -> 로그인 한 경우 게시물은 scrollview로 보이도록 만들 예정
 -> 남의 프로필에 들어가는 경우에는 똑같은 화면에서 뒤로가기 + 신고하기
 */
