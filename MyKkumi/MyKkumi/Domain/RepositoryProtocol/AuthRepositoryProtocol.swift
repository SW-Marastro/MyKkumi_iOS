//
//  AuthRepositoryProtocol.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/16/24.
//

import Foundation
import RxSwift
public protocol AuthRepository {
    func signinKakao(auth: AuthVO) -> Single<Result<Bool, AuthError>>
    func kakaoAPICall() -> Single<Result<OAuthToken, AuthError>>
    func siginApple(_ auth : AppleAuth) -> Single<Result<Bool, AuthError>>
    func patchUserData(_ user : PatchUserVO) -> Single<Result<UserVO, AuthError>>
}
