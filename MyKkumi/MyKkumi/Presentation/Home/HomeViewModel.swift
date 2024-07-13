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
    var getPost : PublishSubject<Int> {get}
}

public protocol HomeviewModelOutput {
    var bannerDataOutput : Signal<[BannerVO]> { get }//전체 배너 정보 view로 전달 -> output
    var shouldPushBannerView : Driver<BannerVO>{ get } // 눌린 배너 상세 정보 view로 전달
    var shouldPushBannerInfoView : Driver<Void> { get } // 전체 베너보기 버튼 결과 전달
    
    var showPostTableView : Driver<Void> { get }
    var deliverCursor : Driver<String?> { get }
    var deliverPostCount : Driver<Int> { get }
    var deliverPost : Driver<PostVO> { get }
    var deliverBannerDetailViewModel : Signal<BannerCellViewModelProtocol> {get}
}

public protocol HomeViewModelProtocol : HomeviewModelOutput, HomeViewModelInput {
    var cursur : Observable<String?> { get }
    var postObserve : Observable<[PostVO]> { get }
    var postRelay : BehaviorRelay<[PostVO]> { get }
}

public class HomeViewModel : HomeViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let bannerUsecase : BannerUsecase
    private let postUsecase : PostUsecase
    private let bannerDetailViewModel : BannerCellViewModelProtocol = BannerCellViewModel()
    
    public init(bannerUsecase : BannerUsecase = injector.resolve(BannerUsecase.self), postUsecase : PostUsecase = injector.resolve(PostUsecase.self)) {
        self.bannerUsecase = bannerUsecase
        self.postUsecase = postUsecase
        self.viewdidload = PublishSubject<Void>()
        self.postTap = PublishSubject<Int64>()
        self.uploadPostButtonTap = PublishSubject<Void>()
        self.getPost = PublishSubject<Int>()
        self.getPostsData = BehaviorSubject<String?>(value: nil)
        self.deliverBannerDetailViewModel = Signal.empty()
        self.postRelay = BehaviorRelay<[PostVO]>(value: [])

        //MARK: Banner
        let allBannerResult = self.viewdidload
            .flatMap {_ in
                return bannerUsecase.getBanners()
            }
            .share()
        
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
            .share()
        
        self.shouldPushBannerInfoView = self.bannerDetailViewModel
            .allBannerPageTap
            .asDriver(onErrorJustReturn: ())
        
        self.shouldPushBannerView = bannerResult
            .compactMap { result -> BannerVO? in
                switch result {
                case .success(let response) : return response
                case .failure(_) : return nil
                }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        self.deliverBannerDetailViewModel = Single.just(bannerDetailViewModel)
            .asSignal(onErrorSignalWith: .empty())
        
        //MARK: Post
        let allPostResult = self.getPostsData
            .flatMap { cursur in
                return postUsecase.getPosts(cursur)
            }
            .share()
                
        self.cursur = allPostResult
            .compactMap { result -> String? in
                switch result {
                case .success(let response) :
                    return response.cursor
                case .failure(_) :
                    return nil
                }
            }
        
        self.postObserve = allPostResult
            .compactMap { result -> [PostVO]? in
                switch result {
                case .success(let response) :
                    return response.posts
                case .failure(_) :
                    return nil
                }
            }
            .withLatestFrom(postRelay.asObservable()) { newPosts, currentPosts in
                print(currentPosts)
                print(newPosts)
                return currentPosts + newPosts
            }
        
        self.deliverPostCount = self.postObserve
            .map { posts in
                return posts.count
            }
            .asDriver(onErrorDriveWith: .empty())
        
        self.showPostTableView = allPostResult
            .map { _ in
                return ()
            }
            .asDriver(onErrorDriveWith: .empty())
            
        self.deliverCursor = self.cursur
            .asDriver(onErrorDriveWith: .empty())

        self.deliverPost = self.getPost
            .withLatestFrom(self.postObserve) { index, posts in
                return posts[index]
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var viewdidload: PublishSubject<Void>
    public var bannerDataOutput: Signal<[BannerVO]>
    public var shouldPushBannerView: Driver<BannerVO>
    public var shouldPushBannerInfoView: Driver<Void>
    public var deliverBannerDetailViewModel: Signal<BannerCellViewModelProtocol>
    
    public var getPost: PublishSubject<Int>
    public var cursur: Observable<String?>
    public var postTap : PublishSubject<Int64>
    public var uploadPostButtonTap : PublishSubject<Void>
    public var getPostsData: BehaviorSubject<String?>
    public var postObserve: Observable<[PostVO]>
    public var postRelay : BehaviorRelay<[PostVO]>
    
    public var showPostTableView : Driver<Void>
    public var deliverCursor: Driver<String?>
    public var deliverPostCount: Driver<Int>
    public var deliverPost: Driver<PostVO>
}
