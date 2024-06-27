//
//  BasicDataSource.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import RxSwift
import Moya

public protocol BasicDataSource {
    func getHelloWolrd() -> Single<Result<HelloWorld, HelloWordError>>
}

public class DefaultBasicDataSource : BasicDataSource {
    let moyaProvider = MoyaProvider<BasicTitle>()
    
    public func getHelloWolrd() -> Single<Result<HelloWorld, HelloWordError>> {
        return moyaProvider.rx.request(.getTitle)
            .filterSuccessfulStatusCodes()
            .map(HelloWorld.self)
            .map { .success($0) } //성공적인 응답을 Result 타입의 success로 매핑한다.
            .catch { error in //에러 발생시 해당 에러를 HelloWordError로 반환하고 .failure로 매핑한다.
                let customError: HelloWordError
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response):
                        customError = .serverError("Server returned status code \(response.statusCode)")
                    default:
                        customError = .unknownError
                    }
                } else {
                    customError = .unknownError
                }
                return .just(.failure(customError))
            }
    }
}