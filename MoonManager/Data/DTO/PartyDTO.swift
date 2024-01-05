//
//  PartyDTO.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public struct PartyDTO: Codable {
    public var id: String
    public var name: String
    public var members: [MemberDTO]
}
