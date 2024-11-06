//
//  MypageViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/21/24.
//

import Foundation
import RxSwift
import RxCocoa

public protocol MypageViewModelInputProtocol {
    var viewdidload : PublishSubject<Void> { get }
}

public protocol MypageViewModelOutputProtocol {

}

public protocol MypageViewModelProtocol : MypageViewModelInputProtocol, MypageViewModelOutputProtocol {
    
}

public class MypageViewModel : MypageViewModelProtocol {
    let disposeBag = DisposeBag()
    
    init() {
        self.viewdidload = PublishSubject<Void>()
    }
    
    public var viewdidload: PublishSubject<Void>
}
