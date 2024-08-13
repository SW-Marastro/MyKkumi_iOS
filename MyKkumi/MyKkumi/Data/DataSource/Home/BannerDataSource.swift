//
//  BannerDataSource.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation
import RxSwift
import Moya

public protocol BannerDataSource {
    func getBanners() -> Single<Result<BannersVO, BannerError>>
    func getBanner(_ id : String) -> Single<Result<BannerVO, BannerError>>
}

public class DefaultBannerDataSource : BannerDataSource {
    public func getBanners() -> Single<Result<BannersVO, BannerError>> {
        return bannerProvier.rx.request(.getBanners)
            .filterSuccessfulStatusCodes()
            .map(BannersVO.self)
            .map{ .success($0) }
            .catch { error in
                let customError : ErrorVO
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case.statusCode(let response) :
                        if let error = try? JSONDecoder().decode(ErrorVO.self, from : response.data) {
                            customError = error
                        } else {
                            customError = ErrorVO(errorCode: "DECODING_ERROR", message: "Decoding Error in Error case", detail: "Error case decoding fail")
                        }
                    default :
                        customError = ErrorVO(errorCode: "unknown", message: "unknown error", detail: "unknown error")
                    }
                } else {
                    customError = ErrorVO(errorCode: "unknown", message: "unknown error", detail: "unknown error")
                }
                
                return .just(.failure(BannerError.unknownError(customError)))
            }
    }
    
    public func getBanner(_ id : String) -> Single<Result<BannerVO, BannerError>> {
        return bannerProvier.rx.request(.getBanner(id))
            .filterSuccessfulStatusCodes()
            .map(BannerVO.self)
            .map{ .success($0)}
            .catch { error in
                let customError : ErrorVO
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case.statusCode(let response) :
                        if let error = try? JSONDecoder().decode(ErrorVO.self, from : response.data) {
                            customError = error
                        } else {
                            customError = ErrorVO(errorCode: "DECODING_ERROR", message: "Decoding Error in Error case", detail: "Error case decoding fail")
                        }
                    default :
                        customError = ErrorVO(errorCode: "unknown", message: "unknown error", detail: "unknown error")
                    }
                } else {
                    customError = ErrorVO(errorCode: "unknown", message: "unknown error", detail: "unknown error")
                }
                return .just(.failure(BannerError.unknownError(customError)))
            }
    }
}
