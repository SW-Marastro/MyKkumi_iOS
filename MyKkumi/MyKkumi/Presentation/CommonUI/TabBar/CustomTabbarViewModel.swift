//
//  CustomTapbarViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol CustomTabbarViewModelInputProtocol {
    var tabBarButtonTap : PublishSubject<Int> { get }
    var addPostButtonTap : PublishSubject<Void> { get }
}

protocol CustomTabbarViewModelOutputProtocol {
    var changeButtonImage : Driver<Int> { get }
    var shouldPushUploadPostView : Driver<Void> { get }
}

protocol CustomTabbarViewModelProtocol : CustomTabbarViewModelInputProtocol, CustomTabbarViewModelOutputProtocol {
    var viewControllers : BehaviorRelay<[UIViewController]> { get }
    var selectedButton : BehaviorRelay<Int> { get }
}

public class CustomTabbarViewModel : CustomTabbarViewModelProtocol{
    private let disposeBag = DisposeBag()
    
    private let homeVC = HomeViewController()
    private let aroundVC = AroundViewController()
    private let shoppingVC = ShoppingViewController()
    private let mypageVC = MypageViewController()
    
    init() {
        self.viewControllers = BehaviorRelay<[UIViewController]>(value: [homeVC, aroundVC, shoppingVC, mypageVC])
        homeVC.setupBind(viewModel: HomeViewModel())
        
        self.selectedButton = BehaviorRelay<Int>(value: 0)
        
        self.tabBarButtonTap = PublishSubject<Int>()
        self.addPostButtonTap = PublishSubject<Void>()
        self.changeButtonImage = tabBarButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        
        let isLogined = self.addPostButtonTap
            .map { _ in
                return KeychainHelper.shared.load(key: "accessToken") != nil
            }
        
        isLogined
            .filter { $0 }
            .subscribe(onNext: { _ in
                NotificationCenter.default.post(name: .showAuth, object: nil)
            })
            .disposed(by: disposeBag)
        
        self.shouldPushUploadPostView = isLogined
            .filter { !$0 }
            .map {_ in
                return Void()
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public var tabBarButtonTap: PublishSubject<Int>
    public var addPostButtonTap: PublishSubject<Void>
    
    public var changeButtonImage: Driver<Int>
    public var shouldPushUploadPostView: Driver<Void>
    
    public var viewControllers: BehaviorRelay<[UIViewController]>
    public var selectedButton: BehaviorRelay<Int>
}
