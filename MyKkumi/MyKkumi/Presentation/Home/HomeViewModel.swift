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
    var shouldReloadPostTable : Signal<Void> { get }
    var shouldPushReport : Driver<[String : Int]> { get }
    var shouldPushReportCompleteAlert : Driver<String> { get }
    var shouldPushReportErrorAlert : Driver<String> { get }
    var shouldPushReportPostAlert : Driver<String> { get }
    var shouldPushReportPostErrorAlert : Driver<String> { get }
}

public protocol HomeViewModelProtocol : HomeviewModelOutput, HomeViewModelInput {
    var cursur : BehaviorRelay<String> { get }
    var postViewModels : BehaviorRelay<[PostCellViewModelProtocol]> { get }
    var bannerViewModel : BehaviorRelay<BannerCellViewModelProtocol> { get }
    var bannerViewUsed : BehaviorRelay<Bool> { get }
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
        self.cursur = BehaviorRelay<String>(value: "")
        self.postViewModels = BehaviorRelay<[PostCellViewModelProtocol]>(value: [])
        self.reportButtonTapInput = PublishSubject<[String : Int]>()
        self.postReported = PublishSubject<Int>()
        self.userReported = PublishSubject<String>()
        self.bannerViewModel = BehaviorRelay<BannerCellViewModelProtocol>(value: bannerDetailViewModel)
        self.bannerViewUsed = BehaviorRelay<Bool> (value: true)

        //MARK: Banner
        let allBannerResult = self.viewdidload
            .flatMap {_ in
                return bannerUsecase.getBanners()
            }
            .share()
        
        let refreshResult = self.viewdidload
            .flatMap {_ -> Observable<Bool> in
                if KeychainHelper.shared.load(key: "refreshToken") != nil {
                    return Observable.just(true)
                } else {
                    return Observable.just(false)
                }
            }
            .share()
        
        refreshResult
            .filter {$0}
            .flatMap {_ in
                return authUsecase.getUserData()
            }
            .compactMap{$0.successValue()}
            .subscribe(onNext: { user in
                if user.nickname == nil {
                    KeychainHelper.shared.delete(key: "accessToken")
                    KeychainHelper.shared.delete(key: "refreshToken")
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
        
        self.shouldPushBannerInfoView = self.bannerDetailViewModel.bannerPageTap
            .asDriver(onErrorJustReturn: ())
        
        self.shouldPushBannerView = bannerResult
            .compactMap { $0.successValue() }
            .asDriver(onErrorDriveWith: .empty())
        
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
        
        self.shouldPushReportPostAlert = postReportResult
            .compactMap { $0.successValue() }
            .map { _ in "신고가 완료되었습니다." }
            .asDriver(onErrorDriveWith: .empty())
        
        self.shouldPushReportPostErrorAlert = postReportResult
            .compactMap{ result in
                if let error = result.failureValue() {
                    switch error {
                    case .unknownError(_):
                        return "알수 없는 에러입니다."
                    case .ENCODING_ERROR:
                        return "에러가 발생하였습니다."
                    case .DECODING_ERROR:
                        return "에러가 발생하였습니다."
                    case .INVALID_VALUE:
                        return "올바르지 못한 신고입니다."
                    }
                }
                return nil
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let userReportResult = self.userReported
            .flatMap { uuid in
                return authUsecase.reportUser(uuid)
            }
            .share()
        
        self.shouldPushReportCompleteAlert = userReportResult
            .compactMap{ $0.successValue() }
            .map { _ in "신고가 완료되었습니다."}
            .asDriver(onErrorDriveWith: .empty())
        
        self.shouldPushReportErrorAlert = userReportResult
            .compactMap{ result in
                if let error = result.failureValue() {
                    switch error {
                    case .CONFLICT:
                        return "이미 신고한 포스트입니다."
                    case .NOTFOUND:
                        return "삭제된 포스트 입니다."
                    case .unknownError(_):
                        return "알수 없는 에러입니다."
                    case .INVALIDTOKEN:
                        return "올바르지 못한 토큰입니다."
                    }
                }
                return nil
            }
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
    public var shouldReloadPostTable: Signal<Void>
    public var shouldPushReport: Driver<[String : Int]>
    public var shouldPushReportCompleteAlert: Driver<String>
    public var shouldPushReportPostAlert: Driver<String>
    public var shouldPushReportErrorAlert: Driver<String>
    public var shouldPushReportPostErrorAlert: Driver<String>
    
    public var postTap : PublishSubject<Int64>
    public var uploadPostButtonTap : PublishSubject<Void>
    public var getPostsData: BehaviorSubject<String?>
    public var reportButtonTapInput: PublishSubject<[String : Int]>
    public var postReported: PublishSubject<Int>
    public var userReported: PublishSubject<String>
    
    public var cursur: BehaviorRelay<String>
    public var postViewModels: BehaviorRelay<[any PostCellViewModelProtocol]>
    public var bannerViewModel: BehaviorRelay<any BannerCellViewModelProtocol>
    public var bannerViewUsed: BehaviorRelay<Bool>
}
