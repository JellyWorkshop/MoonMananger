//
//  ServiceAssembly.swift
//  MoonManager
//
//  Created by cschoi on 1/8/24.
//

import Foundation
import Swinject
import RealmSwift

public struct ServiceAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(Realm.self) { resolver in
            let objectTypes = [
                PartyRealmDTO.self,
                MemberRealmDTO.self,
                SpendingRealmDTO.self
            ]
            let config = Realm.Configuration(schemaVersion: 1,
                                             deleteRealmIfMigrationNeeded: true,
                                             objectTypes: objectTypes)
            return try! Realm(configuration: config)
        }
    }
}
