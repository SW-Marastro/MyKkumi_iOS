//
//  CustomTabBarController.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CustomTabBarController: BaseViewController<CustomTabbarViewModelProtocol> {
    var viewModel : CustomTabbarViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupBind(viewModel: CustomTabbarViewModelProtocol) {
        self.viewModel  = viewModel
        
        self.homeButton.rx.tap
            .map { self.homeButton.tag }
            .bind(to: viewModel.tabBarButtonTap)
            .disposed(by: disposeBag)
        
        self.browseButton.rx.tap
            .map { self.browseButton.tag }
            .bind(to: viewModel.tabBarButtonTap)
            .disposed(by: disposeBag)
        
        self.shoppingButton.rx.tap
            .map { self.shoppingButton.tag }
            .bind(to: viewModel.tabBarButtonTap)
            .disposed(by: disposeBag)
        
        self.myPageButton.rx.tap
            .map { self.myPageButton.tag }
            .bind(to: viewModel.tabBarButtonTap)
            .disposed(by: disposeBag)
        
        self.addpostButton.rx.tap
            .bind(to: self.viewModel.addPostButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.changeButtonImage
            .drive(onNext: {[weak self] tag in
                guard let self = self else { return }
                let preTag = self.viewModel.selectedButton.value
                let preVC = self.viewModel.viewControllers.value[preTag]
                preVC.willMove(toParent: nil)
                preVC.view.removeFromSuperview()
                preVC.removeFromParent()
                self.setView(tag)
                self.setButton(tag)
                self.viewModel.selectedButton.accept(tag)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.shouldPushUploadPostView
            .drive(onNext : {[weak self] _ in
                let makePostVC = MakePostViewController()
                makePostVC.setupBind(viewModel: MakePostViewModel())
                makePostVC.hidesBottomBarWhenPushed  = true
                self?.navigationController?.pushViewController(makePostVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupHierarchy() {
        view.addSubview(tabBarView)
        tabBarView.addSubview(homeButton)
        tabBarView.addSubview(browseButton)
        tabBarView.addSubview(addpostButton)
        tabBarView.addSubview(shoppingButton)
        tabBarView.addSubview(myPageButton)
        
        self.setView(0)
    }
    
    override func setupLayout() {
        let buttonWidth = view.bounds.width / CGFloat(5)
        
        NSLayoutConstraint.activate([
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: buttonWidth + 35)
        ])
        
        NSLayoutConstraint.activate([
            homeButton.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant: -34),
            homeButton.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: CGFloat(homeButton.tag) * buttonWidth),
            homeButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            homeButton.heightAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        NSLayoutConstraint.activate([
            browseButton.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant: -34),
            browseButton.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: CGFloat(browseButton.tag) * buttonWidth),
            browseButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            browseButton.heightAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        NSLayoutConstraint.activate([
            addpostButton.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant: -34),
            addpostButton.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: CGFloat(2) * buttonWidth),
            addpostButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            addpostButton.heightAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        NSLayoutConstraint.activate([
            shoppingButton.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant: -34),
            shoppingButton.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: CGFloat(shoppingButton.tag + 1) * buttonWidth),
            shoppingButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            shoppingButton.heightAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        NSLayoutConstraint.activate([
            myPageButton.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant: -34),
            myPageButton.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: CGFloat(myPageButton.tag + 1) * buttonWidth),
            myPageButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            myPageButton.heightAnchor.constraint(equalToConstant: buttonWidth)
        ])
    }
    
    let tabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.white.color

        // 모서리를 둥글게 만들기
       view.layer.cornerRadius = 20
       view.layer.masksToBounds = false
       
       // 그림자 효과 추가
        view.layer.shadowColor = AppColor.neutral900.color.cgColor
       view.layer.shadowOpacity = 0.2
       view.layer.shadowOffset = CGSize(width: 0, height: -2)
       view.layer.shadowRadius = 10
        
        return view
    }()
    
    let homeButton : UIButton = {
        let button = UIButton()
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(AppImage.homeSelected.image, for: .normal)
        return button
    }()
    
    let browseButton : UIButton = {
        let button = UIButton()
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(AppImage.browseUnselected.image, for: .normal)
        return button
    }()
    
    let addpostButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(AppImage.addPostButton.image, for: .normal)
        return button
    }()
    
    let shoppingButton : UIButton = {
        let button = UIButton()
        button.tag = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(AppImage.shoppingUnselected.image, for: .normal)
        return button
    }()
    
    let myPageButton : UIButton = {
        let button = UIButton()
        button.tag = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(AppImage.mypageUnselected.image, for: .normal)
        return button
    }()
    
    func setView(_ tag : Int) {
        self.addChild(viewModel.viewControllers.value[tag])
        view.insertSubview(viewModel.viewControllers.value[tag].view, belowSubview: tabBarView)
        viewModel.viewControllers.value[tag].view.frame = view.bounds
        viewModel.viewControllers.value[tag].didMove(toParent: self)
    }
    
    func setButton(_ tag : Int) {
        self.homeButton.setImage(AppImage.homeUnselected.image, for: .normal)
        self.browseButton.setImage(AppImage.browseUnselected.image, for: .normal)
        self.shoppingButton.setImage(AppImage.shoppingUnselected.image, for: .normal)
        self.myPageButton.setImage(AppImage.mypageUnselected.image, for: .normal)
        
        switch tag {
        case 0 :
            homeButton.setImage(AppImage.homeSelected.image, for: .normal)
        case 1 :
            browseButton.setImage(AppImage.browseSelected.image, for: .normal)
        case 2 :
            shoppingButton.setImage(AppImage.shoppingSelected.image, for: .normal)
        case 3 :
            myPageButton.setImage(AppImage.mypageSelected.image, for: .normal)
        default :
            return
        }
    }
}

protocol TabBarDelegate: AnyObject {
    func shouldHideTabBar(_ hide: Bool)
}

extension CustomTabBarController: TabBarDelegate {
    func shouldHideTabBar(_ hide: Bool) {
        tabBarView.isHidden = hide
    }
}
