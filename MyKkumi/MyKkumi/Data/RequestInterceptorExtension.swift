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
        var accessToken = ""
        if let result = KeychainHelper.shared.load(service: "accessToken") {
            accessToken = String(data : result, encoding: .utf8)!
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
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
        if let refreshData = KeychainHelper.shared.load(service: "refreshToken") {
            let refreshToken = String(data: refreshData, encoding: .utf8)!
            return authProvider.rx.request(.getToken(refreshToken))
                .filterSuccessfulStatusCodes()
                .map { response in
                    let tokens = try JSONDecoder().decode(AuthVO.self, from: response.data)
                    let accessTokenSaved = KeychainHelper.shared.save(tokens.accessToken.data(using: .utf8)!, service: "accessToken")
                    return accessTokenSaved
                }
        } else {
            return .just(false)
        }
    }
}
