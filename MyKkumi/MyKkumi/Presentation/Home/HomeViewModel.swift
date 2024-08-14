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
    var shouldPushUploadPostView : Driver<Void> { get }
    var deliverBannerViewModel : Signal<BannerCellViewModelProtocol> {get}
}

public protocol HomeViewModelProtocol : HomeviewModelOutput, HomeViewModelInput {
    var cursur : BehaviorSubject<String> { get }
    var postViewModels : BehaviorRelay<[PostCellViewModelProtocol]> { get }
    var shouldReloadPostTable : Signal<Void> { get }
}

public class HomeViewModel : HomeViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let bannerUsecase : BannerUsecase
    private let postUsecase : PostUsecase
    private let authUsecase : AuthUsecase
    private let bannerDetailViewModel : BannerCellViewModelProtocol = BannerCellViewModel()
    
    public init(bannerUsecase : BannerUsecase = DependencyInjector.shared.resolve(BannerUsecase.self), postUsecase : PostUsecase = DependencyInjector.shared.resolve(PostUsecase.self),
                authUsecase : AuthUsecase = DependencyInjector.shared.resolve(AuthUsecase.self)) {
        self.bannerUsecase = bannerUsecase
        self.postUsecase = postUsecase
        self.authUsecase = authUsecase
        self.viewdidload = PublishSubject<Void>()
        self.postTap = PublishSubject<Int64>()
        self.uploadPostButtonTap = PublishSubject<Void>()
        self.getPostsData = BehaviorSubject<String?>(value: nil)
        self.deliverBannerViewModel = Signal.empty()
        self.cursur = BehaviorSubject<String>(value: "")
        self.postViewModels = BehaviorRelay<[PostCellViewModelProtocol]>(value: [])
        

        //MARK: Banner
        let allBannerResult = self.viewdidload
            .flatMap {_ in
                return bannerUsecase.getBanners()
            }
            .share()
        
        self.viewdidload
            .subscribe(onNext: {
                if KeychainHelper.shared.load(key: "refreshToken") != nil {
                    authUsecase.refreshToken()
                }
            })
            .disposed(by: disposeBag)
        
        self.bannerDataOutput = allBannerResult
            .compactMap { $0.successValue()?.banners}
            .asSignal(onErrorSignalWith: .empty())
        
        let bannerResult = self.bannerDetailViewModel.bannerPageTap
            .flatMap {id in
                return bannerUsecase.getBanner(String(id))
            }
            .share()
        
        self.shouldPushBannerInfoView = self.bannerDetailViewModel
            .allBannerPageTap
            .asDriver(onErrorJustReturn: ())
        
        self.shouldPushBannerView = bannerResult
            .compactMap { $0.successValue() }
            .asDriver(onErrorDriveWith: .empty())
        
        self.deliverBannerViewModel = Single.just(bannerDetailViewModel)
            .asSignal(onErrorSignalWith: .empty())
        
        //MARK: Post
        
        let initPostResult = self.viewdidload
            .flatMap { _ in
                return postUsecase.getPosts(nil)
            }
        
        let initSuccessPost = initPostResult
            .compactMap{ $0.successValue() }
        
        let allPostResult = self.getPostsData
            .flatMap { cursur in
                return postUsecase.getPosts(cursur)
            }
            .share()
        
        let successAllPostResult = allPostResult
            .compactMap{ $0.successValue() }
     
        
        self.shouldReloadPostTable = self.postViewModels
            .map{_ in Void()}
            .asSignal(onErrorSignalWith: .empty())
        
        let isLogined = self.uploadPostButtonTap
            .map { _ in
                return KeychainHelper.shared.load(key: "accessToken") != nil
            }
        
        isLogined
            .filter { $0 }
            .subscribe(onNext: { _ in
                NotificationCenter.default.post(name: .showAuth, object: nil)
            })
            .disposed(by: disposeBag)
        
        self.shouldPushUploadPostView = isLogined
            .filter { !$0 }
            .map {_ in
                return Void()
            }
            .asDriver(onErrorDriveWith: .empty())
        
        initSuccessPost
            .subscribe(onNext: {[weak self] result in
                guard let self = self else {return}
                self.cursur.onNext(result.cursor)
                let tmpViewModel = result.posts.map { post in
                    PostCellViewModel(post)
                }
                self.postViewModels.accept(tmpViewModel)
            })
            .disposed(by: disposeBag)
        
        successAllPostResult
            .subscribe(onNext: {[weak self] result in
                guard let self = self else { return }
                self.cursur.onNext(result.cursor)
                var tmpPostViewModels = self.postViewModels.value
                result.posts.forEach { post in
                    tmpPostViewModels.append(PostCellViewModel(post))
                }
                self.postViewModels.accept(tmpPostViewModels)
            })
            .disposed(by: disposeBag)
        
        //MARK: Post Tap
        
    }
    
    public var viewdidload: PublishSubject<Void>
    public var bannerDataOutput: Signal<[BannerVO]>
    public var shouldPushBannerView: Driver<BannerVO>
    public var shouldPushBannerInfoView: Driver<Void>
    public var deliverBannerViewModel: Signal<BannerCellViewModelProtocol>
    
    public var cursur: BehaviorSubject<String>
    public var postTap : PublishSubject<Int64>
    public var uploadPostButtonTap : PublishSubject<Void>
    public var getPostsData: BehaviorSubject<String?>
    
    public var shouldPushUploadPostView: Driver<Void>
    public var postViewModels: BehaviorRelay<[any PostCellViewModelProtocol]>
    public var shouldReloadPostTable: Signal<Void>
}
