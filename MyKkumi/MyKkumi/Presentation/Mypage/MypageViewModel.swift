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
    var logoutButtonTap : PublishSubject<Void> { get }
    var deleteIdButtonTap : PublishSubject<Void> { get }
}

public protocol MypageViewModelOutputProtocol {
    var sholudAlertDeleteComplet : Driver<String> { get }
}

public protocol MypageViewModelProtocol : MypageViewModelInputProtocol, MypageViewModelOutputProtocol {
    
}

public class MypageViewModel : MypageViewModelProtocol {
    let disposeBag = DisposeBag()
    
    init() {
        self.logoutButtonTap = PublishSubject<Void>()
        self.deleteIdButtonTap = PublishSubject<Void>()
        
        let logoutResult = self.logoutButtonTap
            .flatMapLatest {_ -> Observable<String> in
                print("logoutbutton tap")
                if let _ = KeychainHelper.shared.load(key: "accessToken") {
                    KeychainHelper.shared.delete(key: "accessToken")
                    KeychainHelper.shared.delete(key: "refreshToken")
                    return Observable.just("로그아웃이 완료되었습니다.")
                } else {
                    return Observable.just("로그인이 필요합니다.")
                }
            }
        
        self.sholudAlertDeleteComplet = logoutResult
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var logoutButtonTap: PublishSubject<Void>
    public var deleteIdButtonTap: PublishSubject<Void>
    
    public var sholudAlertDeleteComplet: Driver<String>
}
