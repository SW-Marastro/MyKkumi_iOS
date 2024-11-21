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
    var reportButtonTap : PublishSubject<[String : Int]> { get }
    var pinButtonTap : PublishSubject<[String : Int]> { get }
}

public protocol PostCellViewModelOutput {
    var showPinInfo : Driver<Pin?> { get }
}

public protocol PostCellViewModelProtocol : PostCellViewModelInput, PostCellViewModelOutput {
    var showedImage : BehaviorRelay<Int> { get }
    var post : BehaviorRelay<PostVO> { get }
}

public class PostCellViewModel : PostCellViewModelProtocol {
    
    public init(_ post : PostVO) {
        self.post = BehaviorRelay<PostVO> (value: post)
        self.showedImage = BehaviorRelay<Int> (value: 0)
        self.reportButtonTap = PublishSubject<[String : Int]> ()
        self.pinButtonTap = PublishSubject<[String : Int]> ()
        
        self.showPinInfo = pinButtonTap
            .compactMap { postInfo in
                guard let targetUrl = postInfo.keys.first else { return nil }
                let posts = post.images
                for post in posts {
                    if post.url == targetUrl {
                        return post.pins[postInfo[targetUrl]!]
                    }
                }
                return nil
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var showedImage: BehaviorRelay<Int>
    public var post: BehaviorRelay<PostVO>
    
    public var reportButtonTap: PublishSubject<[String : Int]>
    public var pinButtonTap: PublishSubject<[String : Int]>
    
    public var showPinInfo: Driver<Pin?>
}
