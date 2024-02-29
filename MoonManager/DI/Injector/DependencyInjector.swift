//
//  DependencyInjector.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Swinject

// 등록 관련 프로토콜
public protocol DependencyAssemblable {
    func assemble(_ assemblyList: [Assembly])
    func register<T>(_ serviceType: T.Type, _ object: T)
}

// 사용 관련 프로토콜
public protocol DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type) -> T
    func resolve<T, Arg>(_ serviceType: T.Type, argument: Arg) -> T
    func resolve<T, Arg1, Arg2>(_ serviceType: T.Type, arguments: Arg1, _ arg2: Arg2) -> T
    func resolve<T, Arg1, Arg2, Arg3>(_ serviceType: T.Type, arguments: Arg1,_ arg2: Arg2, _ arg3: Arg3) -> T
    func resolve<T, Arg1, Arg2, Arg3, Arg4>(_ serviceType: T.Type, arguments: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> T
}

// Injector 타입은 DependencyAssemblable, DependencyResolvable 프로토콜을 따름
public typealias Injector = DependencyAssemblable & DependencyResolvable

// Injector 프로토콜에 따라 메소드 구현
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
    
    public func resolve<T, Arg>(_ serviceType: T.Type, argument: Arg) -> T {
        container.resolve(serviceType, argument: argument)!
    }
    
    public func resolve<T, Arg1, Arg2>(_ serviceType: T.Type, arguments: Arg1, _ arg2: Arg2) -> T {
        container.resolve(serviceType, arguments: arguments, arg2)!
    }
    
    public func resolve<T, Arg1, Arg2, Arg3>(_ serviceType: T.Type, arguments: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> T {
        container.resolve(serviceType, arguments: arguments, arg2, arg3)!
    }
    
    public func resolve<T, Arg1, Arg2, Arg3, Arg4>(_ serviceType: T.Type, arguments: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> T {
        container.resolve(serviceType, arguments: arguments, arg2, arg3, arg4)!
    }
}
