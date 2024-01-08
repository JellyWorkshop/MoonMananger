//
//  Spending.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public struct Spending: Identifiable {
    public var id: String
    public var title: String
    public var cost: Int
    public var manager: Member
    public var members: [Member]
}

extension Spending: Convertable {
    typealias E = SpendingDTO
    
    init(DTO: SpendingDTO) {
        self.id = DTO.id
        self.title = DTO.title
        self.cost = DTO.cost
        self.manager = Member(DTO: DTO.manager)
        self.members = DTO.members.map { Member(DTO: $0) }
    }
}
