//
//  TestViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/8/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol TestviewModelProtocol {
    var viewdidLoad : PublishSubject<Void> {get}
    var getData : Signal<Int>{get}
}

class TestViewModel  : TestviewModelProtocol {
    var viewdidLoad: RxSwift.PublishSubject<Void>
    
    var getData: RxCocoa.Signal<Int>
    
    public init() {
        self.viewdidLoad = PublishSubject<Void>()
        self.getData = viewdidLoad
            .map {10}
            .asSignal(onErrorSignalWith: .empty())
    }
}
