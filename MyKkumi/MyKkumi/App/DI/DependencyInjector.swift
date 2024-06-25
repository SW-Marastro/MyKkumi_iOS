//
//  DependencyInjector.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import Swinject

//DI 대상 등록
public protocol DependencyAssemblable {
    func assemble(_ assemplyList : [Assembly])
    func register<T>(_ serviceType : T.Type, _ object : T)
}

/// DI 등록한 서비스 사용
public protocol DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type) -> T
}

public typealias Injector = DependencyAssemblable & DependencyResolvable

/// 의존성 주입을 담당하는 인젝터
public final class DependencyInjector: Injector {
    private let container: Container
    
    public init(container: Container) {
        self.container = container
    }
    
    public func assemble(_ assemblyList: [Assembly]) {
        assemblyList.forEach {
            $0.assemble(container: container)
        }
    }
    
    public func register<T>(_ serviceType: T.Type, _ object: T) {
        container.register(serviceType) { _ in object }
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(serviceType)!
    }
}
