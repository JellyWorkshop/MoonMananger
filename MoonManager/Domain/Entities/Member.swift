//
//  Member.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public struct Member: Identifiable {
    public var id: String
    public var name: String
    
    init(id: String = UUID().uuidString, name: String = "") {
        self.id = id
        self.name = name
    }
}

extension Member: Convertable {
    typealias E = MemberDTO
    
    init(DTO: MemberDTO) {
        self.id = DTO.id
        self.name = DTO.name
    }
}
