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
}

/*
public protocol DependencyAssemblable {
    func assemble(_ assemblies: [Assembly])
    func register<T>(_ serviceType: T.Type, _ object: T, name: String?)
}

extension DependencyAssemblable {
    func register<T>(_ serviceType: T.Type, _ object: T, name: String? = nil) {
        self.register(serviceType, object, name: name)
    }
}

public protocol DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type, name: String?) -> T
}

extension DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type, name: String? = nil) -> T {
        self.resolve(serviceType, name: name)
    }
}

public typealias DependencyInjector = DependencyAssemblable & DependencyResolvable

public final class DefaultDependencyInjector: DependencyInjector {
    private let assembler: Assembler
    private let container: Container
    
    public init(container: Container = Container(defaultObjectScope: .container)) {
        self.container = container
        self.assembler = Assembler(container: container)
    }
    
    public func assemble(_ assemblies: [Assembly]) {
        assembler.apply(assemblies: assemblies)
    }
    
    public func resolve<T>(_ serviceType: T.Type, name: String?) -> T {
        assembler.resolver.resolve(serviceType, name: name)!
    }
    
    public func resolve<T>(_ serviceType: T.Type, name: String?) -> T {
        
    }
    
    public func register<T>(_ serviceType: T.Type, _ object: T, name: String?) {
        container.register(serviceType, name: name) { _ in object }
    }
}*/
