//
//  BasicRepository.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import RxSwift
import Moya

public class DefaultBasicRespository : BasicRespository {
    let dataSource : BasicDataSource
    
    public init(dataSource: BasicDataSource) {
        self.dataSource = dataSource
    }
    
    public func getHelloWorld() -> Single<Result<HelloWorld, HelloWordError>> {
        return dataSource.getHelloWolrd()
    }
}
