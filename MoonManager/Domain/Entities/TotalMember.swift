//
//  TotalMember.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 2/2/24.
//

import Foundation

public struct TotalMember: Identifiable {
    public var id: String
    public var member: Member
    public var cost: Int
    
    init(id: String,
         member: Member,
         cost: Int = 0) {
        self.id = id
        self.member = member
        self.cost = cost
    }
}
