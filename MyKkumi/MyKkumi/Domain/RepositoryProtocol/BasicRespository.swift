//
//  BasicRespository.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import RxSwift

public protocol BasicRespository {
    func getHelloWorld() -> Single<Result<HelloWorld, HelloWordError>>
}
