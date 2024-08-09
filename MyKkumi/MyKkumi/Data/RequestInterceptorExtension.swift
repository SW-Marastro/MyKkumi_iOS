//
//  RequestInterceptorExtension.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/30/24.
//

import Foundation
import Alamofire
import RxSwift

class NetworkInterceptor : RequestInterceptor {
    let retryLimit = 5
    let retryDelay : TimeInterval = 5
    let disposeBag = DisposeBag()
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = KeychainHelper.shared.load(key: "accessToken") {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        //urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        completion(.success(urlRequest))
    }

    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        if let statusCode = response?.statusCode, statusCode == 401, request.retryCount < retryLimit {
            refreshAccessToken()
                .subscribe(onSuccess: { success in
                    if success {
                        completion(.retry)
                    } else {
                        completion(.doNotRetry)
                    }
                }, onFailure : {_  in
                    completion(.doNotRetry)
                })
                .disposed(by: disposeBag)
        }
        completion(.doNotRetry)
    }
    
    private func refreshAccessToken() -> Single<Bool> {
        if let refreshToken = KeychainHelper.shared.load(key: "refreshToken") {
            let object = RefreshToekn(refreshToken: refreshToken)
            return authProvider.rx.request(.refreshToken(object))
                .filterSuccessfulStatusCodes()
                .map { response in
                    let tokens = try JSONDecoder().decode(AuthVO.self, from: response.data)
                    let accessTokenSaved = KeychainHelper.shared.save(tokens.accessToken, key: "accessToken")
                    return accessTokenSaved
                }
        } else {
            return .just(false)
        }
    }
}

let interceptor : RequestInterceptor =  NetworkInterceptor()
let session = Session(interceptor : interceptor)
