//
//  ResultExtension.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/13/24.
//

import Foundation
import RxSwift

extension Result {
    func successValue() -> Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    func failureValue() -> Failure? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
