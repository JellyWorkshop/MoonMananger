//
//  Party.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public struct Party: Identifiable {
    public var id: String
    public var name: String
    public var members: [Member]
    public var image: String?
}

extension Party: Convertable {
    typealias E = PartyDTO
    
    init(DTO: PartyDTO) {
        self.id = DTO.id
        self.name = DTO.name
        self.members = DTO.members.map { Member(DTO: $0) }
        self.image = DTO.image
    }
}
