//
//  ViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/16/24.
//

import Foundation
import UIKit
import RxCocoa
import Moya
import RxSwift

private let disposeBag = DisposeBag()

public protocol HelloWordData {
    var helloWord : Observable<String?> {get}
    var buttontaps : PublishSubject<Void>{ get }
}

public class ViewModel :  HelloWordData {
    private let basicUseCase : BasicUsecase
    
    public init(basicUsecase : BasicUsecase) {
        self.basicUseCase = basicUsecase
        self.buttontaps = PublishSubject<Void>()
        self.helloWord = self.buttontaps
            .flatMapLatest {_ in
                basicUsecase.getHelloWorld()
            }
    }
    
    public var helloWord: Observable<String?>
    public var buttontaps : PublishSubject<Void>
}
