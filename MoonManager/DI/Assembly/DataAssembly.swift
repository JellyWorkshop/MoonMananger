//
//  DataAssembly.swift
//  MoonManager
//
//  Created by cschoi on 1/4/24.
//

import Foundation
import Swinject

public struct DataAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(DataTransferService.self) { resolver in
            return DefaultDataTransferService()
        }
        container.register(PartyServiceRepository.self) { resolver in
            let dataSource = resolver.resolve(DataTransferService.self)!
            return DefaultPartyServiceRepository(dataSource: dataSource)
        }
    }
}
