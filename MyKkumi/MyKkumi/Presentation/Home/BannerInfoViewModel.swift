//
//  BannerInfoViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/1/24.
//
import Foundation
import UIKit
import RxCocoa
import Moya
import RxSwift

private let disposeBag = DisposeBag()

public protocol BannerInfoViewModelInput {
    var viewDidLoad : PublishSubject<Void> {get}
    var bannerTap : PublishSubject<Int> { get }
    var backButtonTap : PublishSubject<Void> { get }
}

public protocol BannerInfoViewOutput {
    var deliverBannerData : Driver<[BannerVO]> { get }
    var shouldPushDetailBanner : Driver<BannerVO> { get }
    var shouldPopView : Driver<Void> { get }
}

public protocol BannerInfoViewModelProtocol : BannerInfoViewOutput, BannerInfoViewModelInput{

}

public class BannerInfoViewModel : BannerInfoViewModelProtocol {
    private let bannerUseCase : BannerUsecase
    
    public init(bannerUseCase : BannerUsecase = DependencyInjector.shared.resolve(BannerUsecase.self)) {
        self.bannerUseCase = bannerUseCase
        self.viewDidLoad = PublishSubject<Void>()
        self.bannerTap = PublishSubject<Int>()
        self.backButtonTap = PublishSubject<Void>()
        
        self.shouldPopView = self.backButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        let bannersDataResult = viewDidLoad
            .flatMap {
                return bannerUseCase.getBanners()
            }
        
        self.deliverBannerData = bannersDataResult
            .compactMap { result -> [BannerVO]? in
                switch result {
                case .success(let response) : return response.banners
                case .failure(_) : return nil
                }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let detailBannerData = bannerTap
            .flatMap {id in
                return bannerUseCase.getBanner(String(id))
            }
        
        self.shouldPushDetailBanner = detailBannerData
            .compactMap {result -> BannerVO? in
                switch result {
                case .success(let response) : return response
                case .failure(_) : return nil
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var deliverBannerData: Driver<[BannerVO]>
    public var shouldPushDetailBanner: Driver<BannerVO>
    public var shouldPopView: Driver<Void>
    
    public var viewDidLoad: PublishSubject<Void>
    public var bannerTap: PublishSubject<Int>
    public var backButtonTap: PublishSubject<Void>
}
