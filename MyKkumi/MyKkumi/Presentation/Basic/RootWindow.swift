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
        let tabBarController = CustomTabBarController()
        tabBarController.delegate = self
        
        let homeVC = HomeViewController()
        homeVC.setupBind(viewModel: HomeViewModel())
        let homeViewController = UINavigationController(rootViewController: homeVC)
        homeViewController.tabBarItem = UITabBarItem(title: nil, image: AppImage.homeSelected.image, tag: 0)
        
        let aroundViewController = UINavigationController(rootViewController: AroundViewController())
        aroundViewController.tabBarItem = UITabBarItem(title: nil, image: AppImage.browseUnselected.image, tag: 1)
        
        let makepost = MakePostViewController()
        let makepostVC = UINavigationController(rootViewController: makepost)
        makepost.setupBind(viewModel: MakePostViewModel())
        makepost.hidesBottomBarWhenPushed = true
        makepostVC.tabBarItem = UITabBarItem(title: nil, image: AppImage.addPostButton.image, tag: 2)
        
        let shoppingViewController = UINavigationController(rootViewController: ShoppingViewController())
        shoppingViewController.tabBarItem = UITabBarItem(title: nil, image: AppImage.shoppingUnselected.image, tag: 3)
        
        let mypageVC = MypageViewController()
        mypageVC.setupBind(viewModel: MypageViewModel())
        let mypageViewController = UINavigationController(rootViewController: mypageVC)
        mypageViewController.tabBarItem = UITabBarItem(title: nil, image: AppImage.mypageUnselected.image, tag: 4)
        
        tabBarController.setViewControllers([homeViewController, aroundViewController, makepostVC, shoppingViewController, mypageViewController], animated: true)
        
        tabBarController.tabBar.backgroundColor = AppColor.white.color
        
        tabBarController.setupLayout()
        
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

extension RootWindow : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let items = tabBarController.tabBar.items else { return }
        for (index, item) in items.enumerated() {
            if index == viewController.tabBarItem.tag {
                // Set the selected image for the selected tab
                switch index {
                case 0:
                    tabBarController.tabBar.isHidden = false
                    item.image = AppImage.homeSelected.image
                case 1:
                    tabBarController.tabBar.isHidden = false
                    item.image = AppImage.browseSelected.image
                case 2:
                    if KeychainHelper.shared.load(key: "accessToken") == nil {
                        NotificationCenter.default.post(name: .showAuth, object: nil)
                        tabBarController.selectedIndex = 0
                        items[0].image = AppImage.homeSelected.image
                    } else {
                        tabBarController.tabBar.isHidden = true
                    }
                case 3:
                    tabBarController.tabBar.isHidden = false
                    item.image = AppImage.shoppingSelected.image
                case 4:
                    tabBarController.tabBar.isHidden = false
                    item.image = AppImage.mypageSelected.image
                default:
                    break
                }
            } else {
                // Set the unselected image for the other tabs
                switch index {
                case 0:
                    item.image = AppImage.homeUnselected.image
                case 1:
                    item.image = AppImage.browseUnselected.image
                case 2:
                    continue
                case 3:
                    item.image = AppImage.shoppingUnselected.image
                case 4:
                    item.image = AppImage.mypageUnselected.image
                default:
                    break
                }
            }
        }
    }
}

