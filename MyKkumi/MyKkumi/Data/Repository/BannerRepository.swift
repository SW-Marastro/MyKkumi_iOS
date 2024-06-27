//
//  BannerRepository.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation
import RxSwift
import Moya

public class DefaultBannerRepository : BannerRepository {
    let dataSource : BannerDataSource
    
    public init(dataSource : BannerDataSource) {
        self.dataSource = dataSource
    }
    
    public func getBanners() -> Single<Result<BannersVO, BannerError>> {
        return dataSource.getBanners()
    }
    
    public func getBanner(_ id: String) -> Single<Result<BannerVO, BannerError>> {
        return dataSource.getBanner(id)
    }
}
