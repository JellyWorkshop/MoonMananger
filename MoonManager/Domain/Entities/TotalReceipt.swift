//
//  TotalReceipt.swift
//  MoonManager
//
//  Created by cschoi on 2/29/24.
//

import Foundation

public struct TotalReceipt: Hashable {
    var manager: Member
    var spending: [Spending]
    var receipts: [Receipts]
}

public struct Receipts: Hashable {
    var settler: Member
    var joined: [Spending]
    var shouldPaidAmount: Int
    var paidForAmount: Int
    var directions: [SettlementDirection]
}

public struct SettlementDirection: Hashable {
    var type: DirectionType
    var from: Member
    var to: Member
    var ammount: Int
}

public enum DirectionType {
    /// 환급
    case refund
    /// 송금
    case send
}

