//
//  RealmDataSourceTests.swift
//  MoonManagerTests
//
//  Created by cschoi on 2/7/24.
//

import XCTest
@testable import MoonManager

final class RealmDataSourceTests: XCTestCase {
    
    let dataSource: RealmDataSourceInterface = RealmDataSource()
    var party: PartyRealmDTO = {
        return PartyRealmDTO(Mock.party1)
    }()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    
    func test_데이터_생성() {
        dataSource.create(party)
        
        XCTAssertTrue(true)
    }
    
}
