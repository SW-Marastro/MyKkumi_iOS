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
    public init() {
        self.buttontaps = PublishSubject<Void>()
        self.helloWord = self.buttontaps
            .flatMapLatest {
                return API.sharedAPI.getHelloworld()
                    .asObservable()
                    .map{result -> String? in
                        switch result {
                        case .success(let helloWrld) :
                            return helloWrld.title
                        case .failure(let error):
                            switch error {
                            case .serverError(let message) :
                                return message
                            case .unknownError :
                                return "unknown error"
                            }
                        }
                    }
            }
    }
    
    public var helloWord: Observable<String?>
    public var buttontaps : PublishSubject<Void>
}
