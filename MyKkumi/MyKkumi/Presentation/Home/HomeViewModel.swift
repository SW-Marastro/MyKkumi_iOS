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
    var reportButtonTapInput : PublishSubject<[String : Int]> { get }
    var postReported : PublishSubject<Int> { get }
    var userReported : PublishSubject<String> { get }
}

public protocol HomeviewModelOutput {
    var bannerDataOutput : Signal<[BannerVO]> { get }//전체 배너 정보 view로 전달 -> output
    var shouldPushBannerView : Driver<BannerVO>{ get } // 눌린 배너 상세 정보 view로 전달
    var shouldPushBannerInfoView : Driver<Void> { get } // 전체 베너보기 버튼 결과 전달
    var deliverBannerViewModel : Signal<BannerCellViewModelProtocol> {get}
    var shouldReloadPostTable : Signal<Void> { get }
    var shouldPushReport : Driver<[String : Int]> { get }
    var shouldPushReportCompleteAlert : Driver<Void> { get }
}

public protocol HomeViewModelProtocol : HomeviewModelOutput, HomeViewModelInput {
    var cursur : BehaviorRelay<String> { get }
    var postViewModels : BehaviorRelay<[PostCellViewModelProtocol]> { get }
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
        self.cursur = BehaviorRelay<String>(value: "")
        self.postViewModels = BehaviorRelay<[PostCellViewModelProtocol]>(value: [])
        self.reportButtonTapInput = PublishSubject<[String : Int]>()
        self.postReported = PublishSubject<Int>()
        self.userReported = PublishSubject<String>()
        

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
        
        let bannerResult = self.bannerDetailViewModel.bannerCellTap
            .flatMap {id in
                return bannerUsecase.getBanner(String(id))
            }
            .share()
        
        self.shouldPushBannerInfoView = self.bannerDetailViewModel
            .bannerPageTap
            .asDriver(onErrorJustReturn: ())
        
        self.shouldPushBannerView = bannerResult
            .compactMap { $0.successValue() }
            .asDriver(onErrorDriveWith: .empty())
        
        self.deliverBannerViewModel = Single.just(bannerDetailViewModel)
            .asSignal(onErrorSignalWith: .empty())
        
        //MARK: Post
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
        
        self.shouldPushReport = self.reportButtonTapInput
            .asDriver(onErrorDriveWith: .empty())
        
        let postReportResult = self.postReported
            .flatMap { id in
                return postUsecase.reportPost(id)
            }
            .share()
        
        self.shouldPushReportCompleteAlert = postReportResult
            .compactMap { $0.successValue() }
            .map { _ in Void() }
            .asDriver(onErrorDriveWith: .empty())
        
        let userReportResult = self.userReported
            .flatMap { uuid in
                return authUsecase.reportUser(uuid)
            }
            .share()
        
        self.shouldPushReportCompleteAlert = userReportResult
            .compactMap{ $0.successValue() }
            .map { _ in Void()}
            .asDriver(onErrorDriveWith: .empty())
        
        successAllPostResult
            .subscribe(onNext: {[weak self] result in
                guard let self = self else { return }
                var tmpPostViewModels = self.postViewModels.value
                self.cursur.accept(result.cursor)
                result.posts.forEach { post in
                    let vm  = PostCellViewModel(post)
                    vm.reportButtonTap
                        .subscribe(onNext: {id in
                            self.reportButtonTapInput.onNext(id)
                        })
                        .disposed(by: self.disposeBag)
                    tmpPostViewModels.append(vm)
                }
                self.postViewModels.accept(tmpPostViewModels)
            })
            .disposed(by: disposeBag)
    }
    
    public var viewdidload: PublishSubject<Void>
    public var bannerDataOutput: Signal<[BannerVO]>
    public var shouldPushBannerView: Driver<BannerVO>
    public var shouldPushBannerInfoView: Driver<Void>
    public var deliverBannerViewModel: Signal<BannerCellViewModelProtocol>
    public var shouldReloadPostTable: Signal<Void>
    public var shouldPushReport: Driver<[String : Int]>
    public var shouldPushReportCompleteAlert: Driver<Void>
    
    public var postTap : PublishSubject<Int64>
    public var uploadPostButtonTap : PublishSubject<Void>
    public var getPostsData: BehaviorSubject<String?>
    public var reportButtonTapInput: PublishSubject<[String : Int]>
    public var postReported: PublishSubject<Int>
    public var userReported: PublishSubject<String>
    
    public var cursur: BehaviorRelay<String>
    public var postViewModels: BehaviorRelay<[any PostCellViewModelProtocol]>
}
