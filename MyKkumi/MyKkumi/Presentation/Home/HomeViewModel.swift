//
//  HomeViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import RxCocoa
import RxSwift

public protocol HomeViewModelInput {
    var viewdidload : PublishSubject<Void> { get } //전체 배너 정보 받아옴 -> input
    var postTap : PublishSubject<Int64> { get }
    var uploadPostButtonTap : PublishSubject<Void> { get }
    var getPostsData : BehaviorSubject<String?> { get }
}

public protocol HomeviewModelOutput {
    var bannerDataOutput : Signal<[BannerVO]> { get }//전체 배너 정보 view로 전달 -> output
    var shouldPushBannerView : Driver<BannerVO>{ get } // 눌린 배너 상세 정보 view로 전달
    var shouldPushBannerInfoView : Driver<Void> { get } // 전체 베너보기 버튼 결과 전달
    var showPostTableView : Driver<PostsVO> { get }
    var deliveryBannerDetailViewModel : Signal<BannerCellViewModelProtocol> {get}
}

public protocol HomeViewModelProtocol : HomeviewModelOutput, HomeViewModelInput {
}

public class HomeViewModel : HomeViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let bannerUsecase : BannerUsecase
    private let postUsecase : PostUsecase
    private let bannerDetailViewModel : BannerCellViewModelProtocol
    
    public init(bannerUsecase : BannerUsecase = injector.resolve(BannerUsecase.self), postUsecase : PostUsecase = injector.resolve(PostUsecase.self)) {
        self.bannerUsecase = bannerUsecase
        self.postUsecase = postUsecase
        self.viewdidload = PublishSubject<Void>()
        self.postTap = PublishSubject<Int64>()
        self.uploadPostButtonTap = PublishSubject<Void>()
        self.getPostsData = BehaviorSubject<String?>(value: nil)
        self.bannerDetailViewModel = BannerCellViewModel()
        self.deliveryBannerDetailViewModel = Signal.empty()
        
        let allBannerResult = self.viewdidload
            .flatMap {_ in
                return bannerUsecase.getBanners()
            }
            .share()
        
        let allPostResult = self.getPostsData
            .flatMap { cursor in
                return postUsecase.getPosts(cursor)
            }
        
        self.bannerDataOutput = allBannerResult
            .compactMap { result -> [BannerVO]? in
                switch result {
                case .success(let response) :
                    return response.banners
                case .failure(_) :
                    return nil
                }
            }
            .asSignal(onErrorSignalWith: .empty())
        
        let bannerResult = self.bannerDetailViewModel.bannerTap
            .flatMap {id in
                return bannerUsecase.getBanner(String(id))
            }
        
        self.shouldPushBannerView = bannerResult
            .compactMap { result -> BannerVO? in
                switch result {
                case .success(let response) : return response
                case .failure(_) : return nil
                }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        self.shouldPushBannerInfoView = self.bannerDetailViewModel.allBannerPageTap
            .asDriver(onErrorJustReturn: ())
        
        self.showPostTableView = allPostResult
            .compactMap { result -> PostsVO? in
                switch result {
                case .success(let response) : return response
                case .failure(_) : return nil
                }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        self.deliveryBannerDetailViewModel = allBannerResult
            .map { [weak self] _ in self?.bannerDetailViewModel }
            .compactMap { $0 } 
            .asSignal(onErrorSignalWith: .empty())
    }
    
    public var viewdidload: PublishSubject<Void>
    public var bannerDataOutput: Signal<[BannerVO]>
    public var shouldPushBannerView: Driver<BannerVO>
    public var shouldPushBannerInfoView: Driver<Void>
    public var postTap : PublishSubject<Int64>
    public var uploadPostButtonTap : PublishSubject<Void>
    public var showPostTableView : Driver<PostsVO>
    public var getPostsData: BehaviorSubject<String?>
    public var deliveryBannerDetailViewModel: Signal<BannerCellViewModelProtocol>
}
