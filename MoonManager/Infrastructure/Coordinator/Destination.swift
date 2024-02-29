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
    case partyMember(party: Party, member: Member, receipt: Receipt)
    case spendingList(id: String)
}
