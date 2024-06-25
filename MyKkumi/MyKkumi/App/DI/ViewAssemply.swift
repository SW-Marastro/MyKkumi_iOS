//
//  ViewAssemply.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import Swinject

public struct ViewAssembly : Assembly {
    public func assemble(container: Container) {
        container.register(ViewModel.self) {resolver in
            let useCase = resolver.resolve(BasicUsecase.self)!
            return ViewModel(basicUsecase: useCase)
        }
        
        container.register(ViewController.self) { resolver in
            let viewModel = resolver.resolve(ViewModel.self)!
            return ViewController(viewModel: viewModel)
        }
    }
}
