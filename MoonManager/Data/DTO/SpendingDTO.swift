//
//  SpendingDTO.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public struct SpendingDTO: Codable {
    var id: String
    var title: String
    var cost: Int
    var manager: MemberDTO
    var members: [MemberDTO]
}
