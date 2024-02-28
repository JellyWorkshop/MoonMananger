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
    
    public func retrieveParty(id: String, _ completion: @escaping (Result<PartyDTO, Error>) -> Void) {
        DispatchQueue.main.async {
            autoreleasepool {
                if let data = self.dataSource.retrieveParty(key: id) {
                    completion(.success(PartyDTO(data)))
                }
            }
        }
    }
    
    public func retrieveMember(id: String, _ completion: @escaping (Result<MemberDTO, Error>) -> Void) {
        DispatchQueue.main.async {
            autoreleasepool {
                if let data = self.dataSource.retrieveMember(key: id) {
                    completion(.success(MemberDTO(data)))
                }
            }
        }
    }
    
//    public func retrieveSpending(_ completion: (Result<[SpendingDTO], Error>) -> Void) {
//        completion(.success(Mock.party2.spendings.map { $0 }))
//    }
    
    public func retrieveAllPartyList(_ completion: @escaping (Result<[PartyDTO], Error>) -> Void) {
        DispatchQueue.main.async {
            autoreleasepool {
                let data: [PartyDTO] = self.dataSource.retrievePartyAll()
//                    .compactMap { $0 as? PartyRealmDTO }
                    .map { realmDTO -> PartyDTO in
                        return PartyDTO(realmDTO)
                    }
                completion(.success(data))
            }
        }
    }
    
    public func createParty(_ dto: PartyDTO, completion: @escaping (Result<[PartyDTO], Error>) -> Void) {
        DispatchQueue.main.async {
            autoreleasepool {
                let realmDTO = PartyRealmDTO(dto)
                self.dataSource.create(realmDTO)
//                let data: [PartyDTO] = self.dataSource.retrieveAll()
////                    .compactMap { $0 as? PartyRealmDTO }
//                    .map { realmDTO -> PartyDTO in
//                        return PartyDTO(realmDTO)
//                    }
//                completion(.success(data))
            }
        }
    }
    
    public func updateParty(_ dto: PartyDTO, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            autoreleasepool {
                let realmDTO = PartyRealmDTO(dto)
                self.dataSource.update(realmDTO)
                completion()
            }
        }
    }
    
    public func updateMember(_ dto: MemberDTO, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            autoreleasepool {
                let realmDTO = MemberRealmDTO(dto)
                self.dataSource.update(realmDTO)
                completion()
            }
        }
    }
    
    public func removeMember(_ key: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            autoreleasepool {
                self.dataSource.deleteMember(key: key)
                completion()
            }
        }
    }
    
    public func removeSpending(_ key: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            autoreleasepool {
                self.dataSource.deleteSpending(key: key)
                completion()
            }
        }
    }
}
