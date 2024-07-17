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
}

protocol CollectCategoryViewModelOutput {
    var categorySuccess : Driver<Void> { get }
}

protocol CollectCategoryViewModelProtocol : CollectCategoryViewModelInput, CollectCategoryViewModelOutput {
    
}

class CollectCategoryViewModel : CollectCategoryViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    init() {
        self.categoryTap = PublishSubject<Void>()
        
        self.categorySuccess = categoryTap
            .asDriver(onErrorJustReturn: ())
    }
    
    public var categoryTap: PublishSubject<Void>
    public var categorySuccess: Driver<Void>
}
