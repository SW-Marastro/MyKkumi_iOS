//
//  MakePostViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/31/24.
//

import Foundation
import RxCocoa
import RxSwift

public protocol SelectedImageViewModelInput {
    //imageTap은 상위 뷰 모델과 상관없이 그냥 본인의 view에 영향을 주면 될듯
    var imageTap : PublishSubject<String> { get }
    var deleteButtonTap : PublishSubject<String> { get }
    var unSelectedCellInput : PublishSubject<Void> { get }
}

public protocol SelectedImageViewModelOutput {
    var selectedCell : Driver<Void> { get }
    var unSelectedCell : Driver<Void> { get }
}

public protocol SelectedImageViewModelProtocol : SelectedImageViewModelInput, SelectedImageViewModelOutput{
    
}

public class SelectedImageViewModel : SelectedImageViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    public init() {
        self.imageTap = PublishSubject<String>()
        self.deleteButtonTap = PublishSubject<String>()
        self.unSelectedCellInput = PublishSubject<Void>()
        
        self.selectedCell = self.imageTap
            .map{_ in }
            .asDriver(onErrorDriveWith: .empty())
        
        self.unSelectedCell = self.unSelectedCellInput
            .asDriver(onErrorDriveWith : .empty())
    }
    
    public var imageTap: PublishSubject<String>
    public var deleteButtonTap: PublishSubject<String>
    public var unSelectedCellInput: PublishSubject<Void>
    
    public var selectedCell: Driver<Void>
    public var unSelectedCell: Driver<Void>
}
