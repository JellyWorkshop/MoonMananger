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
    public var image: String?
    
    public init(
        id: String,
        name: String,
        members: [MemberDTO],
        spendings: [SpendingDTO],
        image: String?
    ) {
        self.id = id
        self.name = name
        self.members = members
        self.spendings = spendings
        self.image = image
    }
    
    public init (party: Party) {
        self.id = party.id
        self.name = party.name
        self.members = party.members.map{
            MemberDTO(id: $0.id, name: $0.name)
        }
        self.spendings = party.spendings.map{
            SpendingDTO(
                id: $0.id,
                title: $0.title,
                cost: $0.cost,
                manager: MemberDTO(
                    id: $0.manager.id,
                    name: $0.manager.name
                ),
                members: $0.members.map {
                    MemberDTO(id: $0.id, name: $0.name)
                }
            )
        }
        self.image = party.image
    }
    
    public init(_ realmDTO: PartyRealmDTO) {
        self.id = realmDTO.id
        self.name = realmDTO.name
        self.members = realmDTO.members.map { MemberDTO($0) }
        self.spendings = realmDTO.spendings.map { SpendingDTO($0) }
    }
}

extension PartyDTO {
    var domain: Party {
        Party(
            id: self.id,
            name: self.name,
            members: self.members.map { $0.doamin },
            spendings: self.spendings.map { $0.domain },
            image: self.image
        )
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
