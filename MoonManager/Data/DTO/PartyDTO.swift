//
//  PartyDTO.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation
import RealmSwift

public class PartyDTO: Codable {
    public var id: String
    public var name: String
    public var members: [MemberDTO]
    public var spendings: [SpendingDTO]
    
    public init(
        id: String,
        name: String,
        members: [MemberDTO],
        spendings: [SpendingDTO]
    ) {
        self.id = id
        self.name = name
        self.members = members
        self.spendings = spendings
    }
    
    public init(_ realmDTO: PartyRealmDTO) {
        self.id = realmDTO.id
        self.name = realmDTO.name
        self.members = realmDTO.members.map { MemberDTO($0) }
        self.spendings = realmDTO.spendings.map { SpendingDTO($0) }
    }
}

public class PartyRealmDTO: Object {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var members: List<MemberRealmDTO>
    @Persisted public var spendings: List<SpendingRealmDTO>
    
    public convenience init(
        id: String,
        name: String,
        members: [MemberRealmDTO],
        spendings: [SpendingRealmDTO]
    ) {
        self.init()
        self.id = id
        self.name = name
        self.members = List()
        self.spendings = List()
        self.members.append(objectsIn: members)
        self.spendings.append(objectsIn: spendings)
    }
    
    public convenience init(_ dto: PartyDTO) {
        self.init()
        self.id = dto.id
        self.name = dto.name
        self.members = List()
        self.spendings = List()
        self.members.append(
            objectsIn: dto.members.map { MemberRealmDTO($0) }
        )
        self.spendings.append(
            objectsIn: dto.spendings.map { SpendingRealmDTO($0) }
        )
    }
}
