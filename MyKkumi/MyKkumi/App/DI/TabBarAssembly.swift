//
//  TabBarAssembly.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import Swinject

public struct TabBarAssembly : Assembly {
    public func assemble(container: Container) {
        container.register(HomeViewModel.self) { resolve in
            return HomeViewModel()
        }
        
        container.register(HomeViewController.self) { resolver in
            let viewModel = resolver.resolve(HomeViewModel.self)!
            return HomeViewController(viewModel: viewModel)
        }
    }
}
