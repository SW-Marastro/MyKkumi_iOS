//
//  MakeProfileViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/15/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MakeProfileViewModelInput {
    var profileImageTap : PublishSubject<Void> { get }
    var infoIconPush : PublishSubject<Void> { get }
    var completeButtonTap : PublishSubject<Void> { get }
}

protocol MakeProfileViewModelOutput {
    
}

protocol MakeProfileViewModelProtocol : MakeProfileViewModelInput, MakeProfileViewModelOutput {
    
}

class MakeProfileViewModel : MakeProfileViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    init() {
        self.profileImageTap = PublishSubject<Void>()
        self.infoIconPush = PublishSubject<Void>()
        self.completeButtonTap = PublishSubject<Void>()
    }
    
    public var profileImageTap: PublishSubject<Void>
    public var infoIconPush: PublishSubject<Void>
    public var completeButtonTap: PublishSubject<Void> = PublishSubject<Void>()
}
