//
//  HomeViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import UIKit
import RxCocoa
import Moya
import RxSwift

private let disposeBag = DisposeBag()

public protocol HomeViewModelProtocol {
    var banners : PublishRelay<[BannerVO]> { get }
    var bannerTap : PublishSubject<Int> {get} //각 cell이 tap된 경우 어떤 action할지
    var bannersData : Signal<Result<BannersVO, BannerError>> {get}
    var bannerData : PublishSubject<Result<BannerVO,BannerError>>{get}
}

public class HomeViewModel : HomeViewModelProtocol {
    private let bannerUseCase : BannerUsecase
    
    public init(bannerUseCase : BannerUsecase) {
        self.bannerUseCase = bannerUseCase
        self.banners = PublishRelay<[BannerVO]>()
        self.bannerTap = PublishSubject<Int>()
        self.bannersData = bannerUseCase.getBanners()
            .asSignal(onErrorRecover: { error in
                if let bannerError = error as? BannerError {
                    return .just(.failure(bannerError))
                } else {
                    let errorVO = ErrorVO(errorCode: "unknown", message: "unknown error", detail: "unknown error")
                    return .just(.failure(BannerError.unknownError(errorVO)))
                }
            })
        self.bannerData = PublishSubject<Result<BannerVO, BannerError>>()
        
        self.bannersData.emit(onNext: { [weak self] result in //이벤트 발생 = emit
            switch result {//이벤트 발생으로 일어나는 일 -> Images에 값 변경 -> 이걸 view에서 구독??
            case .success(let bannersVO):
                let imageUrls = bannersVO.banners.compactMap { $0.imageURL }
                self?.banners.accept(bannersVO.banners)
            case .failure(let error):
                print("Error: \(error)")
            }
        }).disposed(by: disposeBag)
        
        self.bannerTap
        .flatMap { id in
            bannerUseCase.getBanner(String(id))
                .asObservable()
                .materialize()
        }
        .compactMap { $0.element }
        .bind(to: bannerData)
        .disposed(by: disposeBag)

    }
    
    public var banners: PublishRelay<[BannerVO]>
    public var bannerTap: PublishSubject<Int>
    public var bannersData: Signal<Result<BannersVO, BannerError>>
    public var bannerData : PublishSubject<Result<BannerVO,BannerError>>
}
