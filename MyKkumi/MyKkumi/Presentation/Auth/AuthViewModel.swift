//
//  AuthViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/10/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol AuthViewModelInput {
    var appleButtonTap : PublishSubject<Void> { get }
    var kakaoButtonTap : PublishSubject<Void> { get }
}

protocol AuthViewModelOutput {
    var kakaoSuccess : Driver<Void> { get }
    var appleSuccess : Driver<Void> { get }
}

protocol AuthViewModelProtocol : AuthViewModelInput, AuthViewModelOutput {
    
}

class AuthViewModel : AuthViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    init() {
        self.appleButtonTap = PublishSubject<Void>()
        self.kakaoButtonTap  = PublishSubject<Void>()
        
        self.appleSuccess = appleButtonTap
            .asDriver(onErrorJustReturn: ())
        
        self.kakaoSuccess = kakaoButtonTap
            .asDriver(onErrorJustReturn: ())
    }
    
    public var appleButtonTap: PublishSubject<Void>
    public var kakaoButtonTap: PublishSubject<Void>
    public var appleSuccess: Driver<Void>
    public var kakaoSuccess: Driver<Void>
}
