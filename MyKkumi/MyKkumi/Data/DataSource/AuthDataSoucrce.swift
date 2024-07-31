//
//  AuthDataSoucrce.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/16/24.
//

import Foundation
import RxSwift
import Moya
import KakaoSDKUser

public protocol AuthDataSource {
    func signinKakao(auth: AuthVO) -> Single<Result<Bool, AuthError>>
    func kakaoAPICall() -> Single<Result<OAuthToken, AuthError>>
    func signinApple(_ auth : AppleAuth) -> Single<Result<Bool, AuthError>>
    func patchUserData(_ user : PatchUserVO) -> Single<Result<UserVO, AuthError>>
}

public class DefaultAuthDataSource : AuthDataSource {
    
    public func signinKakao(auth: AuthVO) -> Single<Result<Bool, AuthError>> {
        return authProvider.rx.request(.signinKakao(auth))
            .filterSuccessfulStatusCodes()
            .map {response in
                let tokens = try JSONDecoder().decode(AuthVO.self, from: response.data)
                let accessTokenSaved = KeychainHelper.shared.save(tokens.accessToken, key: "accessToken")
                let refreshTokenSaved = KeychainHelper.shared.save(tokens.refreshToken, key: "refreshToken")
                
                if accessTokenSaved && refreshTokenSaved {
                    return .success(true)
                } else {
                    return .failure(AuthError.unknownError(ErrorVO(errorCode: "KeychainError", message: "KeychainError", detail: "KeychainError in Default")))
                }
            }
            .catch { error in
                let customError : ErrorVO
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response) :
                        if (try? JSONDecoder().decode(ErrorVO.self, from : response.data)) != nil {
                            //✅ TODO: 에러 코드별 에러 정의
                            customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in Default")
                            return .just(.failure(AuthError.unknownError(customError)))
                        } else {
                            customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in Default")
                            return .just(.failure(AuthError.unknownError(customError)))
                        }
                    default :
                        customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in Default")
                        return .just(.failure(AuthError.unknownError(customError)))
                    }
                } else {
                    customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in POST")
                    return .just(.failure(AuthError.unknownError(customError)))
                }
            }
    }
    
    public func kakaoAPICall() -> Single<Result<OAuthToken, AuthError>> {
        Single.create { single in
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    if let error = error {
                        let customError = ErrorVO(errorCode: "KakakoAPI Error", message: "KakaoAPI Error", detail: error.localizedDescription)
                        single(.failure(AuthError.unknownError(customError)))
                    } else {
                        guard let oauthToken = oauthToken else {
                            let customError = ErrorVO(errorCode: "KakakoAPI Error", message: "KakaoAPI Error", detail: "Token is nil")
                            single(.failure(AuthError.unknownError(customError)))
                            return
                        }
                        let auth = OAuthToken(refreshToken: oauthToken.refreshToken, accessToken: oauthToken.accessToken)
                        single(.success(.success(auth)))
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error = error {
                        let customError = ErrorVO(errorCode: "KakakoAPI Error", message: "KakaoAPI Error", detail: error.localizedDescription)
                        single(.failure(AuthError.unknownError(customError)))
                    } else {
                        guard let oauthToken = oauthToken else {
                            let customError = ErrorVO(errorCode: "KakakoAPI Error", message: "KakaoAPI Error", detail: "Token is nil")
                            single(.failure(AuthError.unknownError(customError)))
                            return
                        }
                        let auth = OAuthToken(refreshToken: oauthToken.refreshToken, accessToken: oauthToken.accessToken)
                        single(.success(.success(auth)))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    public func signinApple(_ auth: AppleAuth) -> RxSwift.Single<Result<Bool, AuthError>> {
        return authProvider.rx.request(.signinApple(auth))
            .filterSuccessfulStatusCodes()
            .map {response in
                print(response)
                let tokens = try JSONDecoder().decode(AuthVO.self, from: response.data)
                let accessTokenSaved = KeychainHelper.shared.save(tokens.accessToken, key: "accessToken")
                let refreshTokenSaved = KeychainHelper.shared.save(tokens.refreshToken, key: "refreshToken")
                
                if accessTokenSaved && refreshTokenSaved {
                    return .success(true)
                } else {
                    return .failure(AuthError.unknownError(ErrorVO(errorCode: "KeychainError", message: "KeychainError", detail: "KeychainError in Default")))
                }
            }
            .catch { error in
                print(error)
                let customError : ErrorVO
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response) :
                        if (try? JSONDecoder().decode(ErrorVO.self, from : response.data)) != nil {
                            //✅ TODO: 에러 코드별 에러 정의
                            customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in Default")
                            return .just(.failure(AuthError.unknownError(customError)))
                        } else {
                            customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in Default")
                            return .just(.failure(AuthError.unknownError(customError)))
                        }
                    default :
                        customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in Default")
                        return .just(.failure(AuthError.unknownError(customError)))
                    }
                } else {
                    customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in POST")
                    return .just(.failure(AuthError.unknownError(customError)))
                }
            }
    }
    
    public func patchUserData(_ user: PatchUserVO) -> Single<Result<UserVO, AuthError>> {
        return authProvider.rx.request(.patchUser(user))
            .filterSuccessfulStatusCodes()
            .map(UserVO.self)
            .map{ .success($0) }
            .catch {error in
                let customError : ErrorVO
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case.statusCode(let response) :
                        if let error = try? JSONDecoder().decode(ErrorVO.self, from : response.data) {
                            customError = error
                        } else {
                            customError = ErrorVO(errorCode: "unknown", message: "Decoding Error in Error case", detail: "Error case decoding fail")
                        }
                    default :
                        customError = ErrorVO(errorCode: "unknown", message: "Decoding Error in Error case", detail: "Error case decoding fail")
                    }
                } else {
                    customError = ErrorVO(errorCode: "unknown", message: "Decoding Error in Error case", detail: "Error case decoding fail")
                }
                return .just(.failure(AuthError.unknownError(customError)))
            }
    }
}
