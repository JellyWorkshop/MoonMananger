//
//  MoonManagerTests.swift
//  MoonManagerTests
//
//  Created by cschoi on 2/2/24.
//

import XCTest
@testable import MoonManager

final class MoonManagerTests: XCTestCase {
    
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
        let members = party.members.map { SpendingResult(memeber: $0)}
        
        
    }


}

struct SpendingResult {
    var memeber: Member
    var cost: Int = 0
}
