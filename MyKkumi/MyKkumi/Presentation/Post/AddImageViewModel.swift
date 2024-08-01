//
//  AddImageViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/31/24.
//

import Foundation
import RxSwift

public protocol AddImageViewModelProtocol {
    var addButtonTap : PublishSubject<Void> { get }
}

public class AddImageViewModel : AddImageViewModelProtocol {
    
    public init() {
        self.addButtonTap = PublishSubject<Void>()
    }
    
    public var addButtonTap: PublishSubject<Void>
}
