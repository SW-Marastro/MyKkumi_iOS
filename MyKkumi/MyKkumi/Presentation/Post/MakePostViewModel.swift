//
//  MakePostViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/31/24.
//

import Foundation
import RxCocoa
import RxSwift

public protocol MakePostViewModelInput {
    
}

public protocol MakePostViewModelOutput {
    
}

public protocol MakePostViewModelProtocol {
    var selectedImageRelay : BehaviorRelay<[UIImage]>{ get }
}

public class MakePostViewModel : MakePostViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    public init() {
        self.selectedImageRelay = BehaviorRelay<[UIImage]>(value: [])
    }
    
    public var selectedImageRelay: BehaviorRelay<[UIImage]>
}
