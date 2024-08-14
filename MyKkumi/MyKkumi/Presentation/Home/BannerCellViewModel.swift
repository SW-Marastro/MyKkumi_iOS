//
//  BannerDetailViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/8/24.
//

import Foundation
import RxSwift
import RxCocoa

public protocol BannerCellViewModelInput {
    var bannerPageTap : PublishSubject<Int> { get }
}

public protocol BannerCellViewModelOutput {
    
}

public protocol BannerCellViewModelProtocol : BannerCellViewModelInput, BannerCellViewModelOutput {
    
}

public class BannerCellViewModel : BannerCellViewModelProtocol {
    
    public init() {
        self.bannerPageTap = PublishSubject<Int>()
    }
    
    public var bannerPageTap: PublishSubject<Int>
}
