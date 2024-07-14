//
//  DataAssembly.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation
import Swinject

public struct DataAssembly : Assembly {
    public func assemble(container: Container) {
        container.register(BannerDataSource.self) {_ in
            return DefaultBannerDataSource()
        }
        
        container.register(PostDataSource.self) {_ in
            return DefaultPostDataSource()
        }
        
        container.register(BannerRepository.self) {resolver in
            let dataSource = resolver.resolve(BannerDataSource.self)!
            return DefaultBannerRepository(dataSource: dataSource)
        }
        
        container.register(PostRespository.self) {resolver in
            let dataSource = resolver.resolve(PostDataSource.self)!
            return DefaultPostRespository(dataSource: dataSource)
        }
    }
}
