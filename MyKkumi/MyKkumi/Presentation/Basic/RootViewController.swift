//
//  RootViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/19/24.
//

import Foundation
import UIKit

class RootViewController : UIViewController {
    private var authController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        showTapbarController()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAuth), name: .showAuth, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAuth), name: .deleteAuth, object: nil)
    }
    
    private func showTapbarController() {
        let homeVC = HomeViewController()
        homeVC.setupBind(viewModel: HomeViewModel())
        let homeViewController = UINavigationController(rootViewController: homeVC)
        let aroundViewController = UINavigationController(rootViewController: AroundViewController())
        let shoppingViewController = UINavigationController(rootViewController: ShoppingViewController())
        let mypageViewController = UINavigationController(rootViewController: MypageViewController())
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([homeViewController, aroundViewController, shoppingViewController, mypageViewController], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].title = "홈"
            
            items[1].title = "둘러보기"
            
            items[2].title = "쇼핑"
            
            items[3].title = "마이페이지"
        }
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMove(toParent: self)
    }
    
    @objc private func showAuth() {
        let auth = AuthViewController()
        auth.setupBind(viewModel: AuthViewModel())
        self.authController = UINavigationController(rootViewController: auth)
        addChild(authController!)
        view.addSubview(authController!.view)
        auth.view.frame = view.bounds
        auth.didMove(toParent: self)
    }
    
    @objc private func deleteAuth() {
        guard let authController = self.authController else { return }
        authController.willMove(toParent: nil)
        authController.view.removeFromSuperview()
        authController.removeFromParent()
        self.authController = nil
    }
}


