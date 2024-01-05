//
//  DomainAssembly.swift
//  MoonManager
//
//  Created by cschoi on 1/4/24.
//

import Foundation
import Swinject

public struct DomainAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(MainUseCase.self) { resolver in
            let partyRepository = resolver.resolve(PartyServiceRepository.self)!
            return DefaultMainUseCase(partyRepository: partyRepository)
        }
    }
}
