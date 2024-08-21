//
//  MakePostUseCase.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/8/24.
//

import Foundation
import RxSwift

public protocol MakePostUseCase {
    func getCategory() -> Single<Result<CategoriesVO, MakePostError>>
    func getPresignedUrl() -> Single<Result<PreSignedUrlVO, MakePostError>>
    func putImage(url : String, image : Data) -> Single<Result<Bool, MakePostError>>
    func uploadPost(_ post : MakePostVO) -> Single<Result<Bool, MakePostError>>
    func deletePost(_ postId : Int) -> Single<Result<Bool, MakePostError>>
}

public final class DefaultMakePostUsecase : MakePostUseCase {
    
    let repository : MakePostRepository
    
    public init(repository : MakePostRepository) {
        self.repository = repository
    }
    
    public func getCategory() -> RxSwift.Single<Result<CategoriesVO, MakePostError>> {
        return repository.getCategory()
    }
    
    public func getPresignedUrl() -> RxSwift.Single<Result<PreSignedUrlVO, MakePostError>> {
        return repository.getPresignedUrl()
    }
    
    public func putImage(url: String, image: Data) -> Single<Result<Bool, MakePostError>> {
        return repository.putImage(url: url, image: image)
    }
    
    public func uploadPost(_ post: MakePostVO) -> RxSwift.Single<Result<Bool, MakePostError>> {
        return repository.uploadPost(post)
    }
    
    public func deletePost(_ postId: Int) -> RxSwift.Single<Result<Bool, MakePostError>> {
        return repository.deletePost(postId)
    }
}
