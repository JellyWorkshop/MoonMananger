//
//  Receipt.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 2/2/24.
//

import Foundation

public struct Receipt: Identifiable {
    public var id: String
    public var manager: Member
    public var totalMember: [TotalMember]
    
    init(id: String,
         manager: Member,
         totalMember: [TotalMember] = []) {
        self.id = id
        self.manager = manager
        self.totalMember = totalMember
    }
}

public struct TotalReceipt {
    var manager: Member
    var spending: [Spending]
    var receipts: [Receipts]
}

public struct Receipts {
    var settler: Member
    var joined: [Spending]
    var shouldPaidAmount: Int
    var paidForAmount: Int
    var directions: [SettlementDirection]
}

public struct SettlementDirection {
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

