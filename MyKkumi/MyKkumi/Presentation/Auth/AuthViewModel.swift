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
    var appleButtonTap : PublishSubject<Void> { get }
    var kakaoButtonTap : PublishSubject<Void> { get }
}

protocol AuthViewModelOutput {
    var kakaoSuccess : Driver<Bool> { get }
    var appleSuccess : Driver<Void> { get }
}

protocol AuthViewModelProtocol : AuthViewModelInput, AuthViewModelOutput {
    
}

class AuthViewModel : AuthViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let authUsecase : AuthUsecase
    
    init(authUsecase : AuthUsecase = injector.resolve(AuthUsecase.self)) {
        self.authUsecase = authUsecase
        self.appleButtonTap = PublishSubject<Void>()
        self.kakaoButtonTap  = PublishSubject<Void>()
        
        //apple Auth API 호출 필요
        self.appleSuccess = self.appleButtonTap
            .asDriver(onErrorJustReturn: ())
        
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
        
        self.kakaoSuccess = kakaoSignin
            .compactMap{ $0.successValue()}
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var appleButtonTap: PublishSubject<Void>
    public var kakaoButtonTap: PublishSubject<Void>
    public var appleSuccess: Driver<Void>
    public var kakaoSuccess: Driver<Bool>
}
