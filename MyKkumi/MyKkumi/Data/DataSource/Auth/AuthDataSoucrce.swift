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
    func refreshToken()
    func getPresignedUrl() -> Single<Result<PreSignedUrlVO, AuthError>>
    func reportUser(_ uuid : String) -> Single<Result<ReportResult, AuthError>>
}

public class DefaultAuthDataSource : AuthDataSource {
    private var disposeBag = DisposeBag()
    
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
    
    public func refreshToken() {
        if let refreshToken = KeychainHelper.shared.load(key: "refreshToken") {
            let object = RefreshToekn(refreshToken: refreshToken)
            authProvider.rx.request(.refreshToken(object))
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
                .disposed(by: disposeBag)
        }
    }
    
    public func getPresignedUrl() -> Single<Result<PreSignedUrlVO, AuthError>> {
        return authProvider.rx.request(.getPresignedUrl)
            .filterSuccessfulStatusCodes()
            .map(PreSignedUrlVO.self) // map to PreSignedUrlVO
            .map { result in
                return .success(result) // map to success with the url string
            }
            .catch { error in
                let customError: ErrorVO = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in getPresignedUrl")
                return .just(.failure(AuthError.unknownError(customError)))
            }
    }
    
    public func reportUser(_ uuid: String) -> Single<Result<ReportResult, AuthError>> {
        return authProvider.rx.request(.reportUser(uuid))
            .filterSuccessfulStatusCodes()
            .map(ReportResult.self)
            .map { result in
                return .success(result)
            }
            .catch { error in
                let customError : ErrorVO
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response) :
                        if let error =  (try? JSONDecoder().decode(ErrorVO.self, from : response.data)) {
                            customError = error
                            if customError.errorCode == "CONFLICT" {
                                return .just(.failure(AuthError.CONFLICT))
                            } else if customError.errorCode == "NOTFOUNT" {
                                return .just(.failure(AuthError.NOTFOUND))
                            }
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
}
