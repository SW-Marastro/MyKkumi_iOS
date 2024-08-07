//
//  PinInfoViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

public protocol PinInfoViewModelInputProtocol {
    var cancelButtonTap : PublishSubject<Int> { get }
    var saveButtonTap : PublishSubject<Int> { get }
    var productNameInput : BehaviorSubject<String> { get }
    var purchaseInfoInput : BehaviorSubject<String> { get }
}

public protocol PinInfoViewModelOutputProtocol {
    
}

public protocol PinInfoViewModelProtocol : PinInfoViewModelInputProtocol, PinInfoViewModelOutputProtocol{
    var index : Int { get }
    var productName : BehaviorRelay<String> { get }
    var purchaseInfo : BehaviorRelay<String> { get }
}

public class PinInfoViewModel : PinInfoViewModelProtocol {
    private let disposeBag  = DisposeBag()
    public var index: Int
    
    public init(_ index : Int) {
        self.index = index
        self.productNameInput = BehaviorSubject<String>(value: "")
        self.purchaseInfoInput = BehaviorSubject<String>(value: "")
        self.cancelButtonTap = PublishSubject<Int>()
        self.saveButtonTap = PublishSubject<Int>()
        self.productName = BehaviorRelay<String> (value: "")
        self.purchaseInfo = BehaviorRelay<String> (value: "")
        
        self.productNameInput
            .subscribe(onNext: {[weak self] name in
                self?.productName.accept(name)
            })
            .disposed(by: disposeBag)
        
        self.purchaseInfoInput
            .subscribe(onNext: {[weak self] purchase in
                self?.purchaseInfo.accept(purchase)
            })
            .disposed(by: disposeBag)
        
    }
    
    public var cancelButtonTap: PublishSubject<Int>
    public var saveButtonTap: PublishSubject<Int>
    public var productNameInput: BehaviorSubject<String>
    public var purchaseInfoInput: BehaviorSubject<String>
    
    public var productName: BehaviorRelay<String>
    public var purchaseInfo: BehaviorRelay<String>
}
