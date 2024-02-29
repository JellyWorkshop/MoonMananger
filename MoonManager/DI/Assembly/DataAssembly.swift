//
//  DataAssembly.swift
//  MoonManager
//
//  Created by cschoi on 1/4/24.
//

import Foundation
import Swinject
import RealmSwift

public struct DataAssembly: Assembly {
    
    public func assemble(container: Container) {
        
        container.register(PartyServiceRepository.self) { resolver in
            let realm = resolver.resolve(Realm.self)!
            return RealmPartyRepository(realm: realm)
        }
    }
}
