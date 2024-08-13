//
//  PostCategoryViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/12/24.
//

import Foundation
import RxSwift
import RxCocoa

public protocol PostCategoryViewModelInput {
    var viewDidLoad : PublishSubject<Void> { get }
    var categoryButtonTap : PublishSubject<Int> { get }
    var completeButtonTap : PublishSubject<Void> { get }
    var dismissEventInput : PublishSubject<Bool> { get }
}

public protocol PostCategoryViewModelOutput {
    var sholudDrawCategory : Driver<CategoriesVO> { get }
    var dismissView : Driver<Bool> { get }
}

public protocol PostCategoryViewModelProtocol : PostCategoryViewModelInput, PostCategoryViewModelOutput {
    
}

public class PostCategoryViewModel : PostCategoryViewModelProtocol {
    private let makePostUsecase : MakePostUseCase
    
    public init(makePostUsecase : MakePostUseCase = DependencyInjector.shared.resolve(MakePostUseCase.self)) {
        self.makePostUsecase = makePostUsecase
        
        self.viewDidLoad = PublishSubject<Void>()
        self.categoryButtonTap = PublishSubject<Int>()
        self.completeButtonTap = PublishSubject<Void>()
        self.dismissEventInput = PublishSubject<Bool>()
        
        let categoryResult = viewDidLoad
            .flatMap {_ in
                return makePostUsecase.getCategory()
            }
            .share()
        
        self.sholudDrawCategory = categoryResult
            .compactMap { $0.successValue()}
            .asDriver(onErrorDriveWith: .empty())
        
        self.dismissView = self.dismissEventInput
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var viewDidLoad: PublishSubject<Void>
    public var categoryButtonTap: PublishSubject<Int>
    public var completeButtonTap: PublishSubject<Void>
    public var dismissEventInput: PublishSubject<Bool>
    
    public var sholudDrawCategory: Driver<CategoriesVO>
    public var dismissView: Driver<Bool>
}
