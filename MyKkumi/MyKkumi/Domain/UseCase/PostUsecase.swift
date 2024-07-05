//
//  PostUsecase.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import Foundation
import RxSwift

public protocol PostUsecase {
    func getPosts(_ cursor : String?) -> Single<Result<PostsVO, PostError>>
}

public final class DefaultPostUsecase : PostUsecase {
    let repository : PostRespository
    
    public init(repository: PostRespository) {
        self.repository = repository
    }
    
    public func getPosts(_ cursor: String?) -> Single<Result<PostsVO, PostError>> {
        return repository.getPosts(cursor)
    }
}
