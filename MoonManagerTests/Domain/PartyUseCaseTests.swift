//
//  PartyUseCaseTests.swift
//  PartyUseCaseTests
//
//  Created by cschoi on 2/2/24.
//

import XCTest
@testable import MoonManager

final class PartyUseCaseTests: XCTestCase {
    
    var party: Party = {
        let partyDTO = Mock.party1
        return Party(DTO: partyDTO)
    }()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        /// 참여 정산건 평균 비용 = 비용 / 인원수
        /// 내가 낸돈 - 참여 정산건 합
        ///   양수 일경우 받아야함
        ///   음수일경우 총무에게 줘야함
        ///
        
        var receipts: [Receipts] = party.members.map { member in
            let joinedSpending = party.spendings.filter { spending in
                spending.members.contains { $0.id == member.id }
            }
            
            /// 지불해야할 금액
            let shouldPaidAmount: Int = joinedSpending
                .map { spending in
                    spending.cost / spending.members.count
                }.reduce(0) { $0 + $1 }
            
            /// 지불한 금액
            let paidForAmount: Int = joinedSpending
                .filter { $0.manager.id == member.id }
                .reduce(0) { $0 + $1.cost }
            
            return Receipts(
                settler: member,
                joined: joinedSpending,
                shouldPaidAmount: shouldPaidAmount,
                paidForAmount: paidForAmount,
                directions: []
            )
        }
        // 제일 많이 지불한 총무
        var manager = receipts.max { $0.paidForAmount < $1.paidForAmount }!
        receipts = receipts.filter { $0.settler.id != manager.settler.id }
            .map { receipt in
                var receipt = receipt
                let total = receipt.paidForAmount - receipt.shouldPaidAmount
                if total > 0 {
                    receipt.directions = [
                        SettlementDirection(
                            type: .refund,
                            from: manager.settler ,
                            to: receipt.settler,
                            ammount: abs(total)
                        )
                    ]
                } else if total < 0 {
                    receipt.directions = [
                        SettlementDirection(
                            type: .send,
                            from: receipt.settler ,
                            to: manager.settler,
                            ammount: abs(total)
                        )
                    ]
                }
                return receipt
            }
        
        manager.directions = receipts
            .filter { $0.directions.contains { $0.type == .refund } }
            .flatMap { $0.directions }
        
        receipts.append(manager)
        
        let totalReceipt = TotalReceipt(
            manager: manager.settler,
            spending: party.spendings,
            receipts: receipts
        )
        
        XCTAssertTrue(true)
    }


}


/*var totalSpendings: [TotalSpending] = party.members.map { member in
    TotalSpending(
        manager: member,
        cost: party.spendings
            .filter { $0.manager.id == member.id}
            .reduce(0) { $0 + $1.cost }
    )
}
let manager = totalSpendings.max { $0.cost < $1.cost }!.manager
var managerReceipts: Receipts = Receipts(
    settlers: manager,
    joined: [],
    directions: []
)
 
var receipts: [Receipts] = party.members.map { member in
    let joinedSpending = party.spendings.filter { spending in
        spending.members.contains { $0.id == member.id }
    }
    
    // 지불해야할 금액
    let shouldPaidAmount: Int = joinedSpending
        .map { spending in
            spending.cost / spending.members.count
        }.reduce(0) { $0 + $1 }
    
    // 지불한 금액
    let paidForAmount: Int = joinedSpending
        .filter { $0.manager.id == member.id }
        .reduce(0) { $0 + $1.cost }
    
    let total = paidForAmount - shouldPaidAmount
    
    var directions: [SettlementDirection] = []
    if manager.id == member.id {
        
    } else {
        let direction = SettlementDirection(
            from: total > 0 ? manager : member,
            to: total > 0 ? member : manager,
            ammount: Int(UInt(total))
        )
        directions.append(direction)
    }
    
    var receipt: Receipts = Receipts(
        settlers: member,
        joined: joinedSpending,
        directions: directions
    )
    
    return receipt
}*/
