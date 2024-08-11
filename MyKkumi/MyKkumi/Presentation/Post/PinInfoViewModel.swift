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
    var cancelButtonTap : PublishSubject<String> { get }
    var saveButtonTap : PublishSubject<String> { get }
    var productNameInput : BehaviorSubject<String> { get }
    var purchaseInfoInput : BehaviorSubject<String> { get }
}

public protocol PinInfoViewModelOutputProtocol {
    var sholudDismiss : Driver<String> { get }
}

public protocol PinInfoViewModelProtocol : PinInfoViewModelInputProtocol, PinInfoViewModelOutputProtocol{
    var uuId : String { get }
    var productName : BehaviorRelay<String> { get }
    var purchaseInfo : BehaviorRelay<String> { get }
}

public class PinInfoViewModel : PinInfoViewModelProtocol {
    private let disposeBag  = DisposeBag()
    public var uuId: String
    
    public init(_ uuId : String) {
        self.uuId = uuId
        self.productNameInput = BehaviorSubject<String>(value: "")
        self.purchaseInfoInput = BehaviorSubject<String>(value: "")
        self.cancelButtonTap = PublishSubject<String>()
        self.saveButtonTap = PublishSubject<String>()
        self.productName = BehaviorRelay<String> (value: "")
        self.purchaseInfo = BehaviorRelay<String> (value: "")
        
        self.sholudDismiss = self.cancelButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudDismiss = self.saveButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
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
    
    public var cancelButtonTap: PublishSubject<String>
    public var saveButtonTap: PublishSubject<String>
    public var productNameInput: BehaviorSubject<String>
    public var purchaseInfoInput: BehaviorSubject<String>
    
    public var productName: BehaviorRelay<String>
    public var purchaseInfo: BehaviorRelay<String>
    
    public var sholudDismiss: Driver<String>
}
