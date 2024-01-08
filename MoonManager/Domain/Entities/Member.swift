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
}

extension Member: Convertable {
    typealias E = MemberDTO
    
    init(DTO: MemberDTO) {
        self.id = DTO.id
        self.name = DTO.name
    }
}
