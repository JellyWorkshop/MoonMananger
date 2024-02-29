//
//  RealmPartyRepository.swift
//  MoonManager
//
//  Created by cschoi on 2/28/24.
//

import Foundation
import RealmSwift

public final class RealmPartyRepository: PartyServiceRepository {
    
    private let realm: Realm
    private let imageDataSource: ImageDataSourceInterface
    
    init(realm: Realm) {
        self.realm = realm
        self.imageDataSource = ImageDataSource()
    }
    
    public func createParty(_ party: Party, completion: @escaping (Result<Void, Error>) -> Void) {
        let dto = PartyDTO(party: party)
        DispatchQueue.main.async { [weak self] in
            autoreleasepool {
                do {
                    let realmDTO = PartyRealmDTO(dto)
                    try self?.realm.write {
                        self?.realm.add(realmDTO)
                    }
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func retrieveParty(_ key: String, completion: @escaping (Result<Party, Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            autoreleasepool {
                if let data = self?.realm.object(ofType: PartyRealmDTO.self, forPrimaryKey: key) {
                    let dto = PartyDTO(data)
                    completion(.success(dto.domain))
                } else {
                    /// 에러 처리
                }
            }
        }
    }
    
    public func retrieveAllParty(completion: @escaping (Result<[Party], Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            autoreleasepool {
                if let list = self?.realm.objects(PartyRealmDTO.self) {
                    let dto = list.map { PartyDTO($0) }
                    completion(.success(dto.map { $0.domain }))
                } else {
                    /// 에러 처리
                }
            }
        }
    }
    
    public func retrieveMember(_ key: String, completion: @escaping (Result<Member, Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            autoreleasepool {
                if let data = self?.realm.object(ofType: MemberRealmDTO.self, forPrimaryKey: key) {
                    let dto = MemberDTO(data)
                    completion(.success(dto.doamin))
                }  else {
                    /// 에러 처리
                }
            }
        }
    }
    
    public func updateParty(_ party: Party, completion: @escaping (Result<Void, Error>) -> Void) {
        let dto = PartyDTO(party: party)
        DispatchQueue.main.async { [weak self] in
            autoreleasepool {
                do {
                    let realmDTO = PartyRealmDTO(dto)
                    try self?.realm.write {
                        self?.realm.add(realmDTO, update: .modified)
                    }
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func removeMember(_ key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            autoreleasepool {
                do {
                    if let object = self?.realm.object(ofType: MemberRealmDTO.self, forPrimaryKey: key) {
                        try self?.realm.write {
                            self?.realm.delete(object)
                        }
                    }
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func removeSpending(_ key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            autoreleasepool {
                do {
                    if let object = self?.realm.object(ofType: SpendingRealmDTO.self, forPrimaryKey: key) {
                        try self?.realm.write {
                            self?.realm.delete(object)
                        }
                        completion(.success(()))
                    }  else {
                        /// 에러 처리
                        completion(.success(()))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
