//
//  PostDataSource.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import Foundation
import RxSwift
import Moya

public protocol PostDataSource {
    func getPosts(_ cursor : String?) -> Single<Result<PostsVO, PostError>>
    func reportPost(_ id : Int) -> Single<Result<String, PostError>>
}

public class DefaultPostDataSource : PostDataSource {
    public func reportPost(_ id: Int) -> RxSwift.Single<Result<String, PostError>> {
        return Post.report(id).provider.rx.request(.report(id))
            .filterSuccessfulStatusCodes()
            .map(ReportResult.self)
            .map{ .success($0.result) }
            .catch { error in
                let customError : ErrorVO
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response) :
                        if let error = try? JSONDecoder().decode(ErrorVO.self, from: response.data) {
                            customError = error
                            if customError.errorCode == "ENCODING_ERROR" {
                                return .just(.failure(PostError.ENCODING_ERROR))
                            } else if customError.errorCode == "DECODING_ERROR" {
                                return .just(.failure(PostError.DECODING_ERROR))
                            } else if customError.errorCode == "INTERNAL_SERVER_ERROR"{
                                return .just(.failure(PostError.INVALID_VALUE))
                            }
                            else {
                                return .just(.failure(PostError.INVALID_VALUE))
                            }
                        } else {
                            customError = ErrorVO(errorCode: "DECODING_ERROR", message: "Decoding Error in Error case", detail: "Error case decoding fail")
                            return .just(.failure(PostError.DECODING_ERROR))
                        }
                    default :
                        customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in Default")
                        return .just(.failure(PostError.unknownError(customError)))
                    }
                } else {
                    customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in POST")
                    return .just(.failure(PostError.unknownError(customError)))
                }
            }
    }
    
    public func getPosts(_ cursor : String?) -> Single<Result<PostsVO, PostError>> {
        return Post.getPost(cursor).provider.rx.request(.getPost(cursor))
            .filterSuccessfulStatusCodes()
            .map(PostsVO.self)
            .map{ .success($0) }
            .catch { error in
                let customError : ErrorVO
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response) :
                        if let error = try? JSONDecoder().decode(ErrorVO.self, from: response.data) {
                            customError = error
                            if customError.errorCode == "ENCODING_ERROR" {
                                return .just(.failure(PostError.ENCODING_ERROR))
                            } else if customError.errorCode == "DECODING_ERROR" {
                                return .just(.failure(PostError.DECODING_ERROR))
                            } else {
                                return .just(.failure(PostError.INVALID_VALUE))
                            }
                        } else {
                            customError = ErrorVO(errorCode: "DECODING_ERROR", message: "Decoding Error in Error case", detail: "Error case decoding fail")
                            return .just(.failure(PostError.DECODING_ERROR))
                        }
                    default :
                        customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in Default")
                        return .just(.failure(PostError.unknownError(customError)))
                    }
                } else {
                    customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in POST")
                    return .just(.failure(PostError.unknownError(customError)))
                }
            }
    }
}
