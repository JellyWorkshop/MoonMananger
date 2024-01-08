//
//  PartyRealmDTO.swift
//  MoonManager
//
//  Created by cschoi on 1/5/24.
//

import Foundation
import RealmSwift
import Realm

public class PartyRealmDTO: Object {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
    @Persisted public var members: List<MemberRealmDTO>
    @Persisted public var spendings: List<SpendingRealmDTO>
}

public class MemberRealmDTO: Object {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var name: String
}

public class SpendingRealmDTO: Object {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var title: String
    @Persisted public var cost: Int
    @Persisted public var members: List<MemberRealmDTO>
}

