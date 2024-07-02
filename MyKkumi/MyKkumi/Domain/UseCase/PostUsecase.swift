//
//  PostUsecase.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import Foundation
import RxSwift

public protocol PostUsecase {
    func getPosts(_ cursor : String) -> Single<PostsVO>
}

public final class DefaultPostUsecase : PostUsecase {
    let repository : PostRespositoryProtocol
    
    public init(repository: PostRespositoryProtocol) {
        self.repository = repository
    }
    
//    public func getPosts(_ cursor: String) -> Single<PostsVO> {
//        return repository.getPosts(cursor)
//            .flatMap {
//                
//            }
//    }
}
