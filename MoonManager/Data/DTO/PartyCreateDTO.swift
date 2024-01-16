//
//  PartyCreateDTO.swift
//  MoonManager
//
//  Created by cschoi on 1/3/24.
//

import Foundation

public struct PartyCreateDTO: Codable {
    public var name: String
    public var members: [MemberDTO]
}
