//
//  SceneDelegate.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/15/24.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var injector : Injector = DependencyInjector(container: Container())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScence = (scene as? UIWindowScene) else { return }
        
        injector.assemble([BasicAssembly(),
                          BasicDataAssembly(),
                          ViewAssembly()])
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
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
        window = .init(windowScene: windowScence)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

