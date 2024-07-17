//
//  AuthUsecase.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/17/24.
//

import Foundation
import RxSwift

public protocol AuthUsecase {
    func signinKakao(auth: AuthVO) -> Single<Result<AuthVO, AuthError>>
    func kakaoAPICall() -> Single<Result<OAuthToken, AuthError>>
}

public final class DefaultAuthUsecase : AuthUsecase {
    let repository : AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func signinKakao(auth: AuthVO) -> Single<Result<AuthVO, AuthError>> {
        //✅TODO: ServerToken KeyChain 등록 + KeyChain helper 생성
        return repository.signinKakao(auth: auth)
    }
    
    public func kakaoAPICall() -> Single<Result<OAuthToken, AuthError>> {
        return repository.kakaoAPICall()
    }
}
