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
    var setPostData : Driver<PostVO> { get }
}

public protocol PostCellViewModelProtocol : PostCellViewModelInput, PostCellViewModelOutput {
    
}

public class PostCellViewModel : PostCellViewModelProtocol {
    private let post : PostVO
    
    public init(_ post : PostVO) {
        self.post = post
        self.optionButtonTap = PublishSubject<Void>()
        
        self.setPostData = Driver.just(post)
    }
    
    public var optionButtonTap: PublishSubject<Void>
    public var setPostData: Driver<PostVO>
}
