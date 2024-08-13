//
//  MakePostRepository.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/8/24.
//

import Foundation
import RxSwift

public class DefaultMakePostRespository : MakePostRepository {
    
    let dataSource : MakePostDataSource
    
    public init(dataSource : MakePostDataSource) {
        self.dataSource = dataSource
    }
    
    public func getCategory() -> RxSwift.Single<Result<CategoriesVO, MakePostError>> {
        return dataSource.getCategory()
    }
    
    public func getPresignedUrl() -> RxSwift.Single<Result<String, MakePostError>> {
        return dataSource.getPresignedUrl()
    }
    
    public func putImage(url: String, image: Data) -> Single<Result<Bool, MakePostError>> {
        return dataSource.putImage(url: url, image: image)
    }
    
    public func uploadPost(_ post: MakePostVO) -> RxSwift.Single<Result<Bool, MakePostError>> {
        return dataSource.uploadPost(post)
    }
    
    public func deletePost(_ postId: Int) -> RxSwift.Single<Result<Bool, MakePostError>> {
        return dataSource.deletePost(postId)
    }
}
