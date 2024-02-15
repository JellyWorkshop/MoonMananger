//
//  TotalSpending.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 1/11/24.
//

import Foundation

public struct TotalSpending: Identifiable {
    public var id: String
    public var manager: Member
    public var cost: Int
    
    init(id: String = UUID().uuidString,
         manager: Member,
         cost: Int = 0) {
        self.id = id
        self.manager = manager
        self.cost = cost
    }
}
