//
//  PostRespositoryProtocol.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import Foundation
import RxSwift

public protocol PostRespository {
    func getPosts(_ cursor : String?) -> Single<Result<PostsVO, PostError>>
    func reportPost(_ id : Int) -> Single<Result<String, PostError>>
}
