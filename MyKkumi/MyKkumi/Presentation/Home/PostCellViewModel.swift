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
    
}

public protocol PostCellViewModelOutput {
    var setPostData : Driver<PostVO> { get }
}

public protocol PostCellViewModelProtocol : PostCellViewModelInput, PostCellViewModelOutput {
    var showedImage : BehaviorRelay<Int> { get }
}

public class PostCellViewModel : PostCellViewModelProtocol {
    private let post : PostVO
    
    public init(_ post : PostVO) {
        self.post = post
        self.showedImage = BehaviorRelay<Int> (value: 0)
        
        self.setPostData = Driver.just(post)
    }
    
    public var setPostData: Driver<PostVO>
    public var showedImage: BehaviorRelay<Int>
}
