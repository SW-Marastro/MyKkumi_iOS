//
//  AuthUsecase.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/17/24.
//

import Foundation
import RxSwift

public protocol AuthUsecase {
    func signinKakao(auth: AuthVO) -> Single<Result<Bool, AuthError>>
    func kakaoAPICall() -> Single<Result<OAuthToken, AuthError>>
    func signinApple(_ auth : AppleAuth) -> Single<Result<Bool, AuthError>>
    func patchUserData(_ user : PatchUserVO) -> Single<Result<UserVO, AuthError>>
    func refreshToken()
    func getPresignedUrl() -> Single<Result<PreSignedUrlVO, AuthError>>
    func reportUser(_ uuid : String) -> Single<Result<ReportResult, AuthError>>
}

public final class DefaultAuthUsecase : AuthUsecase {
    
    let repository : AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func signinKakao(auth: AuthVO) -> Single<Result<Bool, AuthError>> {
        //✅TODO: ServerToken KeyChain 등록 + KeyChain helper 생성
        return repository.signinKakao(auth: auth)
    }
    
    public func kakaoAPICall() -> Single<Result<OAuthToken, AuthError>> {
        return repository.kakaoAPICall()
    }
    
    public func signinApple(_ auth: AppleAuth) -> Single<Result<Bool, AuthError>> {
        return repository.siginApple(auth)
    }
    
    public func patchUserData(_ user: PatchUserVO) -> Single<Result<UserVO, AuthError>> {
        return repository.patchUserData(user)
    }
    
    public func refreshToken() {
        repository.refreshToken()
    }
    
    public func getPresignedUrl() -> Single<Result<PreSignedUrlVO, AuthError>> {
        return repository.getPresignedUrl()
    }
    
    public func reportUser(_ uuid: String) -> Single<Result<ReportResult, AuthError>> {
        return repository.reportUser(uuid)
    }
}
