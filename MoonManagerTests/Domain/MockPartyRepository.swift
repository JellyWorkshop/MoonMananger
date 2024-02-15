//
//  MockPartyRepository.swift
//  MoonManagerTests
//
//  Created by cschoi on 2/7/24.
//

import Foundation
@testable import MoonManager

class MockPartyRepository: PartyServiceRepository {
    func retrievePartyList(_ completion: (Result<[MoonManager.PartyDTO], Error>) -> Void) {
        let data = [Mock.party1, Mock.party2, Mock.party3]
        completion(.success(data))
    }
    
    func retrieveParty(_ completion: (Result<MoonManager.PartyDTO, Error>) -> Void) {
        completion(.success(Mock.party2))
    }
    
    func retrieveSpending(_ completion: (Result<[MoonManager.SpendingDTO], Error>) -> Void) {
        completion(.success(Mock.party2.spendings.map { $0 }))
    }
    
    func retrieveAllPartyList(_ completion: @escaping (Result<[MoonManager.PartyDTO], Error>) -> Void) {
        
    }
    
    func createParty(_ dto: MoonManager.PartyDTO, completion: @escaping (Result<[MoonManager.PartyDTO], Error>) -> Void) {
        
    }
}
