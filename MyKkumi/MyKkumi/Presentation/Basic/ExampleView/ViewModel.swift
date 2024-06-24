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
    var helloWordDefault : BehaviorSubject<String?> { get }
}

public class ViewModel :  HelloWordData {
    public init() {
//        self.helloWord = PublishSubject<String?>()
        self.helloWord = API.sharedAPI.getHelloworld()
            .map{$0.title}
            .catchAndReturn("Error fetching data")
            .asObservable()
        self.helloWordDefault = BehaviorSubject<String?>(value: "hello world default")
    }
    
    public var helloWord: Observable<String?>
    public var helloWordDefault: BehaviorSubject<String?>
}
