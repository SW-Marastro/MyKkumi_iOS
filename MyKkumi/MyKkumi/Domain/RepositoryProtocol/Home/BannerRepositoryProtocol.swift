//
//  BannerRepository.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation
import RxSwift

public protocol BannerRepository {
    func getBanners() -> Single<Result<BannersVO, BannerError>>
    func getBanner(_ id : String) -> Single<Result<BannerVO, BannerError>>
}
