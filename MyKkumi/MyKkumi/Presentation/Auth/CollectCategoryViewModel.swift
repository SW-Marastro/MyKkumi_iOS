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
    var categoryTap : PublishSubject<Void> { get }
    var nextButtonTap : PublishSubject<Void> { get }
}

protocol CollectCategoryViewModelOutput {
    var categorySuccess : Driver<Void> { get }
    var sholdPushMakeProfile : Driver<Void> { get }
}

protocol CollectCategoryViewModelProtocol : CollectCategoryViewModelInput, CollectCategoryViewModelOutput {
    var categoryRelay : BehaviorRelay<[String]> { get }
}

class CollectCategoryViewModel : CollectCategoryViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    init() {
        self.categoryTap = PublishSubject<Void>()
        self.nextButtonTap = PublishSubject<Void>()
        self.categoryRelay = BehaviorRelay<[String]>(value: ["야구", "골프", "다이어리 꾸미기", "도시락", "맛집탐방", "이북리더기", "뷰티"])
        
        self.categorySuccess = categoryTap
            .asDriver(onErrorJustReturn: ())
        
        self.sholdPushMakeProfile = nextButtonTap
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var categoryTap: PublishSubject<Void>
    public var nextButtonTap: PublishSubject<Void>
    public var categoryRelay: BehaviorRelay<[String]>
    
    public var categorySuccess: Driver<Void>
    public var sholdPushMakeProfile: Driver<Void>
}
