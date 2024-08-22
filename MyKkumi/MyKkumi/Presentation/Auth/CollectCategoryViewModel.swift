//
//  CollectCategoryViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/14/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol CollectCategoryViewModelInput {
    var categoryTap : PublishSubject<Int> { get }
    var nextButtonTap : PublishSubject<Void> { get }
    var viewdDidLoad : PublishSubject<Void> { get }
    var skipButtonTap : PublishSubject<Void> { get }
    var backButtonTap : PublishSubject<Void> { get }
}

protocol CollectCategoryViewModelOutput {
    var shouldPushMakeProfile : Driver<Void> { get }
    var shouldSkipView : Driver<Void> { get }
    var shouldDrawCategory : Driver<CategoriesVO> { get }
    var dismissView : Driver<Void> { get }
}

protocol CollectCategoryViewModelProtocol : CollectCategoryViewModelInput, CollectCategoryViewModelOutput {
    var categoryRelay : BehaviorRelay<[Int]?> { get }
}

class CollectCategoryViewModel : CollectCategoryViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let makepostUseCase : MakePostUseCase
    
    init(makepostUsecase : MakePostUseCase = DependencyInjector.shared.resolve(MakePostUseCase.self)) {
        self.makepostUseCase = makepostUsecase
        
        self.categoryTap = PublishSubject<Int>()
        self.nextButtonTap = PublishSubject<Void>()
        self.viewdDidLoad = PublishSubject<Void>()
        self.skipButtonTap = PublishSubject<Void>()
        self.categoryRelay = BehaviorRelay<[Int]?>(value: nil)
        self.backButtonTap = PublishSubject<Void>()
        
        self.shouldPushMakeProfile = nextButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.shouldSkipView = self.skipButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        let categoryResult = self.viewdDidLoad
            .flatMap {
                return makepostUsecase.getCategory()
            }
            .share()
        
        self.shouldDrawCategory = categoryResult
            .compactMap { $0.successValue()}
            .asDriver(onErrorDriveWith: .empty())
        
        self.dismissView = self.backButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.categoryTap
            .subscribe(onNext: {[weak self] id in
                guard let self = self else { return }
                if let categories = self.categoryRelay.value {
                    var tmpCategorie = categories
                    var index = 0
                    for cId in tmpCategorie {
                        if cId == id {
                            tmpCategorie.remove(at: index)
                            self.categoryRelay.accept(tmpCategorie)
                            return
                        }
                        index += 1
                    }
                    tmpCategorie.append(id)
                    self.categoryRelay.accept(tmpCategorie)
                } else {
                    let categories = [id]
                    self.categoryRelay.accept(categories)
                }
            })
            .disposed(by: disposeBag)
    }
    
    public var categoryTap: PublishSubject<Int>
    public var nextButtonTap: PublishSubject<Void>
    public var viewdDidLoad: PublishSubject<Void>
    public var skipButtonTap: PublishSubject<Void>
    public var categoryRelay: BehaviorRelay<[Int]?>
    public var backButtonTap: PublishSubject<Void>

    public var shouldPushMakeProfile: Driver<Void>
    public var shouldSkipView: Driver<Void>
    public var shouldDrawCategory: Driver<CategoriesVO>
    public var dismissView: Driver<Void>
}
