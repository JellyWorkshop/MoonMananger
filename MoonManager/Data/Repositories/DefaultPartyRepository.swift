//
//  PartyServiceRepository.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public final class DefaultPartyServiceRepository: PartyServiceRepository {
    
    private let dataSource: RealmDataSourceInterface
    private let imageDataSource: ImageDataSourceInterface
    
    init(dataSource: RealmDataSourceInterface) {
        self.dataSource = dataSource
        self.imageDataSource = ImageDataSource()
    }
    
    public func retrievePartyList(_ completion: (Result<[PartyDTO], Error>) -> Void) {
        let data = [Mock.party1, Mock.party2, Mock.party3]
        completion(.success(data))
    }
    
    public func retrieveParty(_ completion: (Result<PartyDTO, Error>) -> Void) {
        completion(.success(Mock.party2))
    }
    
    public func retrieveSpending(_ completion: (Result<[SpendingDTO], Error>) -> Void) {
        completion(.success(Mock.party2.spendings.map { $0 }))
    }
    
    
    public func retrieveAllPartyList(_ completion: @escaping (Result<[PartyDTO], Error>) -> Void) {
        DispatchQueue.global().async {
            autoreleasepool {
                let data: [PartyDTO] = self.dataSource.retrieveAll()
                    .compactMap { $0 as? PartyRealmDTO }
                    .map { realmDTO -> PartyDTO in
                        return PartyDTO(realmDTO)
                    }
                completion(.success(data))
            }
        }
    }
    
    public func createParty(_ dto: PartyDTO, completion: @escaping (Result<[PartyDTO], Error>) -> Void) {
        DispatchQueue.global().async {
            autoreleasepool {
                let realmDTO = PartyRealmDTO(dto)
                self.dataSource.create(realmDTO)
                let data: [PartyDTO] = self.dataSource.retrieveAll()
                    .compactMap { $0 as? PartyRealmDTO }
                    .map { realmDTO -> PartyDTO in
                        return PartyDTO(realmDTO)
                    }
                completion(.success(data))
            }
        }
    }
}
