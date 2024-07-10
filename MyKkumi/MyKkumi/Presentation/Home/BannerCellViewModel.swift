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
    var bannerTap : PublishSubject<Int> {get} //어떤 배너 눌렸는지 input
    var allBannerPageTap : PublishSubject<Void> { get }
}

public protocol BannerCellViewModelOutput {
    var testOutput : Signal <Int> {get}
}

public protocol BannerCellViewModelProtocol : BannerCellViewModelInput, BannerCellViewModelOutput {
    
}

public class BannerCellViewModel : BannerCellViewModelProtocol {
    public var testOutput: RxCocoa.Signal<Int>
    
    
    public init() {
        self.bannerTap = PublishSubject<Int>()
        self.allBannerPageTap = PublishSubject<Void>()
        
        testOutput = allBannerPageTap
            .map {10}
            .asSignal(onErrorSignalWith: .empty())
    }
    
    public var bannerTap: PublishSubject<Int>
    public var allBannerPageTap: PublishSubject<Void>
}
