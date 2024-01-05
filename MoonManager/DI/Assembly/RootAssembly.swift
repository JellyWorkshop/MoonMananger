//
//  RootAssembly.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Swinject

class RootAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(AppEnvironment.self) { resolver in
            return AppEnvironment()
        }
    }
}
