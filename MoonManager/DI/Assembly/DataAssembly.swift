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
        container.register(PartyServiceRepository.self) { resolver in
            let dataSource = resolver.resolve(RealmDataSourceInterface.self)!
            return DefaultPartyServiceRepository(dataSource: dataSource)
        }
    }
}
