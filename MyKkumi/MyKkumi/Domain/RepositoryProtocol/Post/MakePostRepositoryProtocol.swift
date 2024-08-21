//
//  MakePostRepositoryProtocol.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/8/24.
//

import Foundation
import RxSwift

public protocol MakePostRepository {
    func getCategory() -> Single<Result<CategoriesVO, MakePostError>>
    func getPresignedUrl() -> Single<Result<PreSignedUrlVO, MakePostError>>
    func putImage(url : String, image : Data) -> Single<Result<Bool, MakePostError>>
    func uploadPost(_ post : MakePostVO) -> Single<Result<Bool, MakePostError>>
    func deletePost(_ postId : Int) -> Single<Result<Bool, MakePostError>>
}
