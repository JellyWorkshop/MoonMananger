//
//  Party.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public struct Party: Identifiable, Hashable {
    public var id: String
    public var name: String
    public var members: [Member]
    public var spendings: [Spending]
    public var image: String?
}
