//
//  PostRespository.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import Foundation
import RxSwift
import Moya

public class DefaultPostRespository : PostRespository {
    let dataSource : PostDataSource
    
    public init(dataSource : PostDataSource) {
        self.dataSource = dataSource
    }
    
    public func getPosts(_ cursor : String?) -> Single<Result<PostsVO, PostError>> {
        return dataSource.getPosts(cursor)
    }
    
    public func reportPost(_ id: Int) -> Single<Result<String, PostError>> {
        return dataSource.reportPost(id)
    }
}
