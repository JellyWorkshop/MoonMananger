//
//  ServiceAssembly.swift
//  MoonManager
//
//  Created by cschoi on 1/8/24.
//

import Foundation
import Swinject

public struct ServiceAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(RealmDataSourceInterface.self) { resolver in
            return RealmDataSource()
        }
        
    }
}
