//
//  AuthViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/10/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol AuthViewModelInput {
    var kakaoButtonTap : PublishSubject<Void> { get }
    var appleButtonTap : PublishSubject<Void> { get }
    var backButtonTap : PublishSubject<Void> { get }
    var appleUserData : PublishSubject<String> { get }
    var appleAuthError : BehaviorSubject<Error?> { get }
}

protocol AuthViewModelOutput {
    var kakaoSuccess : Driver<Bool> { get }
    var appleSuccess : Driver<Bool> { get }
    var startAppleSignInFlow : Driver<Void> { get }
}

protocol AuthViewModelProtocol : AuthViewModelInput, AuthViewModelOutput {
    
}

class AuthViewModel : AuthViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let authUsecase : AuthUsecase
    
    init(authUsecase : AuthUsecase = DependencyInjector.shared.resolve(AuthUsecase.self)) {
        self.authUsecase = authUsecase
        self.kakaoButtonTap = PublishSubject<Void>()
        self.appleButtonTap = PublishSubject<Void>()
        self.appleUserData = PublishSubject<String>()
        self.appleAuthError = BehaviorSubject<Error?>(value: nil)
        self.backButtonTap = PublishSubject<Void>()
        
        //apple Auth API 호출 필요
        self.startAppleSignInFlow = self.appleButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        let appleSignin = self.appleUserData
            .flatMap {authorizationCode in
                let appleAuth = AppleAuth(authorizationCode: authorizationCode)
                return authUsecase.signinApple(appleAuth)
            }
            .share()
        
        let appleSignedUser = appleSignin
            .compactMap { $0.successValue()}
            .flatMap { auth in
                return authUsecase.getUserData()
            }
            .share()
        
        self.appleSuccess = appleSignedUser
            .compactMap{ $0.successValue()}
            .map { user in
                return user.nickname == nil
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        //Kakao Auth API 호출 필요
        let kakaoResult = self.kakaoButtonTap
            .flatMap {_ in
                return authUsecase.kakaoAPICall()
            }
            .share()
        
        let kakaoSignin = kakaoResult
            .compactMap{ $0.successValue()}
            .flatMap { oAuth in
                let auth = AuthVO(refreshToken: oAuth.refreshToken, accessToken: oAuth.accessToken)
                return authUsecase.signinKakao(auth: auth)
            }
            .share()
        
        let kakaoSignedUser = kakaoSignin
            .compactMap { $0.successValue()}
            .flatMap { auth in
                return authUsecase.getUserData()
            }
            .share()
        
        self.kakaoSuccess = kakaoSignedUser
            .compactMap{ $0.successValue()}
            .map { user in
                return user.nickname == nil
            }
            .asDriver(onErrorDriveWith: .empty())
        
        self.backButtonTap
            .subscribe(onNext : {
                NotificationCenter.default.post(name: .deleteAuth, object: nil)
            })
            .disposed(by: disposeBag)
    }
    
    public var kakaoButtonTap: PublishSubject<Void>
    public var appleButtonTap: PublishSubject<Void>
    public var appleUserData: PublishSubject<String>
    public var appleAuthError: BehaviorSubject<Error?>
    public var backButtonTap: PublishSubject<Void>
    
    public var appleSuccess: Driver<Bool>
    public var kakaoSuccess: Driver<Bool>
    public var startAppleSignInFlow: Driver<Void>
}
