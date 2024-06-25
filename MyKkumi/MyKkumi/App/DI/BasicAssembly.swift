//
//  BasicAssemply.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Swinject

public struct BasicAssembly : Assembly {
    public func assemble(container: Container) {
        container.register(BasicUsecase.self) { resolver in
            let repository = resolver.resolve(BasicRespository.self)!
            return DefaultBasicUsecase(repository: repository)
        }
    }
}
