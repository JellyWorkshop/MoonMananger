//
//  Spending.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public struct Spending: Identifiable, Hashable {
    public var id: String
    public var title: String
    public var cost: Int
    public var manager: Member
    public var members: [Member]
    
    init(
        id: String = UUID().uuidString,
        title: String,
        cost: Int,
        manager: Member,
        members: [Member]
    ) {
        self.id = id
        self.title = title
        self.cost = cost
        self.manager = manager
        self.members = members
    }
}
