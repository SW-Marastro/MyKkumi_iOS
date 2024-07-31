//
//  AppDelegate.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/15/24.
//

import UIKit
import KakaoSDKCommon
import Swinject
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let disposBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: NetworkConfiguration.kakaoKeyValue)
        if let refreshToken = KeychainHelper.shared.load(key: "refreshToken") {
            print("refreshToken : \(refreshToken)")
            authProvider.rx.request(.refreshToken(refreshToken))
                .filterSuccessfulStatusCodes()
                .map { response in
                    let token = try JSONDecoder().decode(ReAccessToken.self, from: response.data)
                    return token.accessToken
                }
                .subscribe(onSuccess: { accessToken in
                    let accessTokenSave = KeychainHelper.shared.save(accessToken, key: "accessToken")
                    if !accessTokenSave {
                        KeychainHelper.shared.delete(key: "accessToken")
                        KeychainHelper.shared.delete(key: "refreshToken")
                    }
                }, onFailure: {error in
                    KeychainHelper.shared.delete(key: "accessToken")
                    KeychainHelper.shared.delete(key: "refreshToken")
                })
                .disposed(by: disposBag)
        } else {
            let accessToken = KeychainHelper.shared.load(key: "accessToken")
            let refreshToken = KeychainHelper.shared.load(key: "refreshToken")
            print("accessToken : \(accessToken)")
            print("refreshToken : \(refreshToken)")
            
            KeychainHelper.shared.delete(key: "accessToken")
            
            
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

