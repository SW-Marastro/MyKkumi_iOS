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
    var sholudAlertLogout : Driver<String> { get }
    var sholudPresentForm : Driver<Void> { get }
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
                if let _ = KeychainHelper.shared.load(key: "accessToken") {
                    KeychainHelper.shared.delete(key: "accessToken")
                    KeychainHelper.shared.delete(key: "refreshToken")
                    return Observable.just("로그아웃이 완료되었습니다.")
                } else {
                    return Observable.just("로그인이 필요합니다.")
                }
            }
        
        let deleteResult = self.deleteIdButtonTap
            .flatMapLatest {_ -> Observable<Bool> in
                if let _ = KeychainHelper.shared.load(key: "accessToken") {
                    return Observable.just(true)
                } else {
                    return Observable.just(false)
                }
            }
        
        self.sholudAlertLogout = logoutResult
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudPresentForm = deleteResult
            .filter{$0}
            .map { _ in Void()}
            .asDriver(onErrorDriveWith: .empty())
        
        self.sholudAlertDeleteComplet = deleteResult
            .filter{!$0}
            .map{_ in "로그인이 필요합니다."}
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var logoutButtonTap: PublishSubject<Void>
    public var deleteIdButtonTap: PublishSubject<Void>
    
    public var sholudAlertDeleteComplet: Driver<String>
    public var sholudPresentForm: Driver<Void>
    public var sholudAlertLogout: Driver<String>
}
