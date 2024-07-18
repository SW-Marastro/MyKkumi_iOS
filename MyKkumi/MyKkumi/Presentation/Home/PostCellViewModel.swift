//
//  PostCellViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/9/24.
//

import Foundation
import RxCocoa
import RxSwift

public protocol PostCellViewModelInput {
    var optionButtonTap : PublishSubject<Void> { get }
}

public protocol PostCellViewModelOutput {
    
}

public protocol PostCellViewModelProtocol : PostCellViewModelInput, PostCellViewModelOutput {
    
}

public class PostCellViewModel : PostCellViewModelProtocol {
    private let post : PostVO
    
    public init(_ post : PostVO) {
        self.post = post
        self.optionButtonTap = PublishSubject<Void>()
    }
    
    public var optionButtonTap: PublishSubject<Void>
}
