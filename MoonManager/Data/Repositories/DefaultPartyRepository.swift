//
//  PartyServiceRepository.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public final class DefaultPartyServiceRepository: PartyServiceRepository {
    
    private let dataSource: DataTransferService
    
    init(dataSource: DataTransferService) {
        self.dataSource = dataSource
    }
    
    public func retrievePartyList(_ completion: (Result<[PartyDTO], Error>) -> Void) {
        let data = [Mock.party1, Mock.party2, Mock.party3]
        completion(.success(data))
    }
    
    public func retrieveParty(_ completion: (Result<PartyDTO, Error>) -> Void) {
        completion(.success(Mock.party1))
    }
    
    public func retrieveSpending(_ completion: (Result<[SpendingDTO], Error>) -> Void) {
        completion(.success(Mock.party1.spending))
    }
    
    public func createParty(_ request: PartyCreateDTO, completion: (Result<[PartyDTO], Error>) -> Void) {
        
    }
    
    public func deleteParty(_ id: String, completion: (Result<[PartyDTO], Error>) -> Void) {
        
    }
    
    public func updateParty(_ request: PartyUpdateDTO, completion: (Result<[PartyDTO], Error>) -> Void) {
        
    }
    
    
}
