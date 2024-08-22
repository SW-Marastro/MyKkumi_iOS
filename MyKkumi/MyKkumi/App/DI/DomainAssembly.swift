//
//  DomainAssembly.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation
import Swinject

public struct DomainAssembly : Assembly {
    public func assemble(container: Container) {
        container.register(BannerUsecase.self) {resolver in
            let repository = resolver.resolve(BannerRepository.self)!
            return DefaultBannerUsecase(repository: repository)
        }
        
        container.register(PostUsecase.self) {resolver in
            let repository = resolver.resolve(PostRespository.self)!
            return DefaultPostUsecase(repository: repository)
        }
        
        container.register(AuthUsecase.self) {resolver in
            let repository = resolver.resolve(AuthRepository.self)!
            return DefaultAuthUsecase(repository: repository)
        }
        
        container.register(MakePostUseCase.self) {resolver in
            let repository = resolver.resolve(MakePostRepository.self)!
            return DefaultMakePostUsecase(repository: repository)
        }
    }
}
