//
//  MakePostDataSource.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/8/24.
//

import Foundation
import RxSwift
import Moya

public protocol MakePostDataSource {
    func getCategory() -> Single<Result<CategoriesVO, MakePostError>>
    func getPresignedUrl() -> Single<Result<String, MakePostError>>
    func putImage(url : String, image : Data) -> Single<Result<Bool, MakePostError>>
    func uploadPost(_ post : MakePostVO) -> Single<Result<Bool, MakePostError>>
    func deletePost(_ postId : Int) -> Single<Result<Bool, MakePostError>>
}

public class DefaultMakePostDataSource : MakePostDataSource {
    public func getCategory() -> RxSwift.Single<Result<CategoriesVO, MakePostError>> {
        return makePostProvider.rx.request(.getCategory)
            .filterSuccessfulStatusCodes()
            .map(CategoriesVO.self)
            .map{ .success($0)}
            .catch { _ in
                let customError :ErrorVO = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in GetCategory")
                return .just(.failure(MakePostError.unknownError(customError)))
            }
    }
    
    public func getPresignedUrl() -> RxSwift.Single<Result<String, MakePostError>> {
        return makePostProvider.rx.request(.getPresignedURL)
            .filterSuccessfulStatusCodes()
            .map( PreSignedUrlVO.self )
            .map{ result in
                    .success(result.url)
            }
            .catch { _ in
                let customError :ErrorVO = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in getPresignedUrl")
                return .just(.failure(MakePostError.unknownError(customError)))
            }
    }
    
    public func putImage(url: String, image: Data) -> Single<Result<Bool, MakePostError>> {
        return putImageToBucketProvider.rx.request(.putImage(url: url, image: image))
            .filterSuccessfulStatusCodes()
            .map{_ in .success(true)}
            .catch { _ in
                let customError :ErrorVO = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in putImage")
                return .just(.failure(MakePostError.unknownError(customError)))
            }
    }
    
    public func uploadPost(_ post: MakePostVO) -> RxSwift.Single<Result<Bool, MakePostError>> {
        return makePostProvider.rx.request(.uploadPost(post))
            .filterSuccessfulStatusCodes()
            .map(MakePostResponse.self)
            .map{ _ in .success(true)}
            .catch { _ in
                let customError :ErrorVO = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in getPresignedUrl")
                return .just(.failure(MakePostError.unknownError(customError)))
            }
    }
    
    public func deletePost(_ postId: Int) -> RxSwift.Single<Result<Bool, MakePostError>> {
        let postId = String(postId)
        return makePostProvider.rx.request(.deletePost(postId))
            .filterSuccessfulStatusCodes()
            .map{ _ in .success(true)}
            .catch { error in
                var customError : ErrorVO
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response) :
                        if let error = try? JSONDecoder().decode(ErrorVO.self, from: response.data) {
                            customError = error
                            if customError.errorCode == "Forbidden" {
                                return .just(.failure(MakePostError.Forbidden))
                            } else if customError.errorCode == "Unauthorized" {
                                return .just(.failure(MakePostError.Unauthorized))
                            } else if customError.errorCode == "Bad Request" {
                                return .just(.failure(MakePostError.BadReqeust))
                            }  else {
                                customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in getPresignedUrl")
                                return .just(.failure(MakePostError.unknownError(customError)))
                            }
                        } else {
                            customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in getPresignedUrl")
                            return .just(.failure(MakePostError.unknownError(customError)))
                        }
                    default :
                        customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in getPresignedUrl")
                        return .just(.failure(MakePostError.unknownError(customError)))
                    }
                }  else {
                    customError = ErrorVO(errorCode: "unknown", message: "UnknownError", detail: "unknownError in getPresignedUrl")
                    return .just(.failure(MakePostError.unknownError(customError)))
                }
            }
    }
}
