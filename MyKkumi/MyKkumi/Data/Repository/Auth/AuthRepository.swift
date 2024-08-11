//
//  AuthRepository.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/16/24.
//

import Foundation
import RxSwift

public class DefaultAuthRepository : AuthRepository {
    
    let dataSource : AuthDataSource
    
    public init(dataSource: AuthDataSource) {
        self.dataSource = dataSource
    }
    
    public func signinKakao(auth: AuthVO) -> Single<Result<Bool, AuthError>> {
        return dataSource.signinKakao(auth: auth)
    }
    
    public func kakaoAPICall() -> Single<Result<OAuthToken, AuthError>> {
        return dataSource.kakaoAPICall()
    }
    
    public func siginApple(_ auth: AppleAuth) -> RxSwift.Single<Result<Bool, AuthError>> {
        return dataSource.signinApple(auth)
    }
    
    public func patchUserData(_ user: PatchUserVO) -> Single<Result<UserVO, AuthError>> {
        return dataSource.patchUserData(user)
    }
    
    public func refreshToken() {
        dataSource.refreshToken()
    }
}