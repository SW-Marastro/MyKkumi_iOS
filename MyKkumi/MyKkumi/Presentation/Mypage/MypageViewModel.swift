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
    var viewDidLoad : PublishSubject<Void> { get }
    var tapProfilSettingButton : PublishSubject<Void> { get }
    var tapSettingButton : PublishSubject<Void> { get }
    var tapLoginButton : PublishSubject<Void> { get }
}

public protocol MypageViewModelOutputProtocol {
    var showUnloginedPage : Driver<Bool> { get }
    var showLoginedPage : Driver<UserVO> { get }
    var showSetProfilView : Driver<Void> { get }
    var showSettingView : Driver<Void> { get }
    var showAuthView : Driver<Void> { get }
}

public protocol MypageViewModelProtocol : MypageViewModelInputProtocol, MypageViewModelOutputProtocol {
    
}

public class MypageViewModel : MypageViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let authUsecase : AuthUsecase
    
    init(authUsecase : AuthUsecase = DependencyInjector.shared.resolve(AuthUsecase.self)) {
        self.authUsecase = authUsecase
        
        self.viewDidLoad = PublishSubject<Void>()
        self.tapProfilSettingButton = PublishSubject<Void>()
        self.tapSettingButton = PublishSubject<Void>()
        self.tapLoginButton = PublishSubject<Void>()
        
        let logined = viewDidLoad
            .flatMap{ _ -> Observable<Bool> in
                if KeychainHelper.shared.load(key: "refreshToken") != nil {
                    return Observable.just(true)
                } else {
                    return Observable.just(false)
                }
            }
            .share()
        
        showUnloginedPage = logined
            .filter { !$0 }
            .asDriver(onErrorDriveWith: .empty())
        
        let userInfo = logined
            .filter{ $0 }
            .flatMap { _ in
                return authUsecase.getUserData()
            }
            .share()
        
        showLoginedPage = userInfo
            .compactMap { $0.successValue() }
            .asDriver(onErrorDriveWith: .empty())
        
        showSetProfilView = tapProfilSettingButton
            .asDriver(onErrorDriveWith: .empty())
        
        showSettingView = tapSettingButton
            .asDriver(onErrorDriveWith: .empty())
        
        showAuthView = tapLoginButton
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var viewDidLoad: PublishSubject<Void>
    public var tapProfilSettingButton: PublishSubject<Void>
    public var tapSettingButton: PublishSubject<Void>
    public var tapLoginButton: PublishSubject<Void>
    
    public var showUnloginedPage: Driver<Bool>
    public var showLoginedPage: Driver<UserVO>
    public var showSetProfilView: Driver<Void>
    public var showSettingView: Driver<Void>
    public var showAuthView: Driver<Void>
}
