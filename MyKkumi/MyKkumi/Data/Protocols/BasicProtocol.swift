//
//  BasicProtocol.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/18/24.
//

import Foundation
import RxSwift
import Moya

public enum ValidationResult {
    case ok(message : String)
    case empty
    case validating
    case failed
}

public enum HelloWordError : Error {
    case unknownError
    case serverError(String)
}

public protocol BasicAPI {
    func getHelloworld() -> Single<Result<HelloWorld, HelloWordError>>
}

extension ValidationResult {
    var isValid : Bool {
        switch self {
        case .ok :
            return true
        default :
            return false
        }
    }
}
