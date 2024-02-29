//
//  Receipt.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 2/2/24.
//

import Foundation

public struct Receipt: Identifiable, Hashable {
    public var id: String
    public var manager: Member
    public var totalMember: [TotalMember]
    
    init(id: String,
         manager: Member,
         totalMember: [TotalMember] = []) {
        self.id = id
        self.manager = manager
        self.totalMember = totalMember
    }
}
