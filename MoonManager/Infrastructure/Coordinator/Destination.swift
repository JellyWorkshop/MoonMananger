//
//  Destination.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import SwiftUI

public enum Destination: Hashable {
    case main
    case party(id: String)
    case partyMember(partyID: String, memberID: String)
    case spendingList(id: String)
}
