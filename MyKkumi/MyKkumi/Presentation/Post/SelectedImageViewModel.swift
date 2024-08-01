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
    
}

public protocol SelectedImageViewModelOutput {
    
}

public protocol SelectedImageViewModelProtocol : SelectedImageViewModelInput, SelectedImageViewModelOutput{
    
}

public class SelectedImageViewModel : SelectedImageViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    public init() {
        self.selectedImageRelay = BehaviorRelay<[UIImage]>(value: [])
    }
    
    public var selectedImageRelay: BehaviorRelay<[UIImage]>
}
