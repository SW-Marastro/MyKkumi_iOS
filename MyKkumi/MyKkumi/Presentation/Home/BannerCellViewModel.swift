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
    var bannerCellTap : PublishSubject<Int> { get }
    var bannerPageTap : PublishSubject<Void> { get }
}

public protocol BannerCellViewModelOutput {
    
}

public protocol BannerCellViewModelProtocol : BannerCellViewModelInput, BannerCellViewModelOutput {
    
}

public class BannerCellViewModel : BannerCellViewModelProtocol {
    
    public init() {
        self.bannerCellTap = PublishSubject<Int>()
        self.bannerPageTap = PublishSubject<Void>()
    }
    
    public var bannerCellTap: PublishSubject<Int>
    public var bannerPageTap: PublishSubject<Void>
}
