//
//  SpendingDTO.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public struct SpendingDTO: Codable {
    var id: String
    var manager: MemberDTO
    var title: String
    var cost: Int
    var members: [MemberDTO]
}
