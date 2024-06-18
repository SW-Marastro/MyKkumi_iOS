//
//  GetTitle.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/18/24.
//

import Foundation
import RxSwift
import Moya

public class API : BasicAPI {
    static let sharedAPI = API()
    
    public func getHelloworld() -> Single<HelloWorld> {
        return titleProvider.rx.request(BasicTitle.getTitle)
            .map(HelloWorld.self)
            .observe(on: MainScheduler.instance)
            .flatMap({ helloworld -> Single<HelloWorld> in
                return Single.just(helloworld)
            })
    }
}
