//
//  AuthRepositoryProtocol.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/16/24.
//

import Foundation
import RxSwift
public protocol AuthRepository {
    func signinKakao(auth: AuthVO) -> Single<Result<AuthVO, AuthError>>
    func kakaoAPICall() -> Single<Result<OAuthToken, AuthError>>
}
