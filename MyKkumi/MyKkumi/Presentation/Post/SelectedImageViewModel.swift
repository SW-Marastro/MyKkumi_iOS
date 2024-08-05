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
    var imageTap : PublishSubject<Void> { get }
    var deleteButtonTap : PublishSubject<Void> { get }
}

public protocol SelectedImageViewModelOutput {
    
}

public protocol SelectedImageViewModelProtocol : SelectedImageViewModelInput, SelectedImageViewModelOutput{
    
}

public class SelectedImageViewModel : SelectedImageViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    public init(_ row : Int) {
        self.indexPathRow = row
        self.imageTap = PublishSubject<Void>()
        self.deleteButtonTap = PublishSubject<Void>()
    }
    private var indexPathRow : Int
    
    public var imageTap: PublishSubject<Void>
    public var deleteButtonTap: PublishSubject<Void>
}
