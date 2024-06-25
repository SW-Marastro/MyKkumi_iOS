//
//  BasiDataAssemply.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import Swinject

public struct BasicDataAssembly : Assembly {
    public func assemble(container: Container) {
        container.register(BasicDataSource.self) { _ in
            return DefaultBasicDataSource()
        }
        
        container.register(BasicRespository.self) { resolver in
            let dataSource = resolver.resolve(BasicDataSource.self)!
            return DefaultBasicRespository(dataSource: dataSource)
        }
    }
}
