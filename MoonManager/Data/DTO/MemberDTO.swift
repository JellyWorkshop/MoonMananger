//
//  MemberDTO.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation
import RealmSwift

public class MemberDTO: Codable {
    public var id: String
    public var name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    public init(_ realmDTO: MemberRealmDTO) {
        self.id = realmDTO.id
        self.name = realmDTO.name
    }
}

public class MemberRealmDTO: Object {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    
    public convenience init(id: String, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    public convenience init(_ dto: MemberDTO) {
        self.init()
        self.id = dto.id
        self.name = dto.name
    }
}
