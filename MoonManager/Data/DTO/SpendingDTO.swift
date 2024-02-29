//
//  SpendingDTO.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation
import RealmSwift

public class SpendingDTO: Codable {
    public var id: String
    public var title: String
    public var cost: Int
    public var manager: MemberDTO?
    public var members: [MemberDTO]
    
    public init(id: String, title: String, cost: Int, manager: MemberDTO?, members: [MemberDTO]) {
        self.id = id
        self.title = title
        self.cost = cost
        self.manager = manager
        self.members = members
    }
    
    public init(_ realmDTO: SpendingRealmDTO) {
        self.id = realmDTO.id
        self.title = realmDTO.title
        self.cost = realmDTO.cost
        if let manager = realmDTO.manager {
            self.manager = MemberDTO(manager)
        }
        self.members = realmDTO.members.map { MemberDTO($0) }
    }
}

extension SpendingDTO {
    var domain: Spending {
        Spending(
            id: self.id,
            title: self.title,
            cost: self.cost,
            manager: self.manager?.doamin ?? Member(),
            members: self.members.map { $0.doamin }
        )
    }
}

public class SpendingRealmDTO: Object {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var title: String
    @Persisted public var cost: Int
    @Persisted public var manager: MemberRealmDTO?
    @Persisted public var members: List<MemberRealmDTO>
    
    public convenience init(id: String, title: String, cost: Int, manager: MemberRealmDTO?, members: [MemberRealmDTO]) {
        self.init()
        self.id = id
        self.title = title
        self.cost = cost
        self.manager = manager
        self.members = List()
        self.members.append(objectsIn: members)
    }
    
    public convenience init(_ dto: SpendingDTO) {
        self.init()
        self.id = dto.id
        self.title = dto.title
        self.cost = dto.cost
        if let manager = dto.manager {
            self.manager =  MemberRealmDTO(manager)
        }
        self.members = List()
        self.members.append(
            objectsIn: dto.members.map { MemberRealmDTO($0) }
        )
    }
}
