//
//  BasicUsecase.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import RxSwift

public protocol BasicUsecase {
    func getHelloWorld() -> Observable<String?>
}

public final class DefaultBasicUsecase : BasicUsecase {
    let repository: BasicRespository
    
    public init(repository : BasicRespository) {
        self.repository = repository
    }
    
    public func getHelloWorld() -> Observable<String?> {
        return repository.getHelloWorld()
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
