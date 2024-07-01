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

public protocol BannerInfoViewModelProtocol {
    var banners : Single<[BannerVO]> { get }//전체 배너 정보 view로 전달 -> output
    var bannersData : Observable<Result<BannersVO, BannerError>> {get} //전체 배너 정보 받아옴 -> input
    var bannerTap : PublishSubject<Int> {get} //각 cell이 tap된 경우 어떤 action할지 -> input 받아옴(어떤 배너 눌렸는지)
    var bannerPageData : Driver<BannerVO>{get} // 눌린 배너 상세 정보 view로 전달
}

public class BannerInfoViewModel : BannerInfoViewModelProtocol {
    
    private let bannerUseCase : BannerUsecase
    
    public init(bannerUseCase : BannerUsecase) {
        self.bannerUseCase = bannerUseCase
        self.bannerTap = PublishSubject<Int>()
        self.bannersData = bannerUseCase.getBanners()
            .asObservable()
            .catch{ error in
                if let bannerError = error as? BannerError {
                    return .just(.failure(bannerError))
                } else {
                    let errorVO = ErrorVO(errorCode: "unknown", message: "unknown error", detail: "unknown error")
                    return .just(.failure(BannerError.unknownError(errorVO)))
                }
            }
        self.banners = self.bannersData
            .flatMap { result -> Single<[BannerVO]> in
                switch result {
                case .success(let bannersVO):
                    return .just(bannersVO.banners)
                case .failure(let error):
                    return .error(error)
                }
            }
            .asSingle()

        self.bannerPageData = self.bannerTap
            .flatMap {
                id in
                bannerUseCase.getBanner(String(id))
                    .asObservable()
                    .flatMap { result -> Observable<BannerVO> in
                        switch result {
                        case .success(let bannerVO) :
                            return Observable.just(bannerVO)
                        case .failure(let error) :
                            return Observable.error(error)
                        }
                    }
                    .asDriver(onErrorDriveWith: .empty())
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var banners: Single<[BannerVO]>
    public var bannerTap: PublishSubject<Int>
    public var bannersData: Observable<Result<BannersVO, BannerError>>
    public var bannerPageData : Driver<BannerVO>
}
