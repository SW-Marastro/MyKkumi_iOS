//
//  BannerUsecase.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation
import RxSwift

public protocol BannerUsecase {
    func getBanners() -> Single<Result<BannersVO, BannerError>>
    func getBanner(_ id : String) -> Single<Result<BannerVO, BannerError>>
}

public final class DefaultBannerUsecase : BannerUsecase {
    let repository : BannerRepository
    
    public init(repository : BannerRepository) {
        self.repository = repository
    }
    
    public func getBanners() -> Single<Result<BannersVO, BannerError>> {
        return repository.getBanners()
    }
    
    public func getBanner(_ id: String) -> Single<Result<BannerVO, BannerError>> {
        return repository.getBanner(id)
    }
}
