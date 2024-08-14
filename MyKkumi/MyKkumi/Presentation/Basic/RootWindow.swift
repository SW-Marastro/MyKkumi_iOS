//
//  RootViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/19/24.
//

import Foundation
import UIKit

class RootWindow : UIWindow {
    private var originalRootViewController: UIViewController?
    
    public override init(windowScene: UIWindowScene){
       super.init(windowScene: windowScene)
       self.setupObservers()
       self.showTapbarController()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        self.rootViewController = tabBarController
    }

    @objc private func showAuth() {
        guard !(rootViewController is AuthViewController) else { return }

        // Save the current rootViewController
        originalRootViewController = rootViewController
        
        let auth = AuthViewController()
        auth.setupBind(viewModel: AuthViewModel())
        let authController = UINavigationController(rootViewController: auth)
        
        // Set the authController as the new rootViewController
        self.rootViewController = authController
    }

    @objc private func deleteAuth() {
        guard let originalRootVC = originalRootViewController else { return }

        // Restore the original rootViewController
        self.rootViewController = originalRootVC
        self.originalRootViewController = nil
    }
}
