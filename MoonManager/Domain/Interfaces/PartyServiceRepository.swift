//
//  PartyServiceRepository.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public protocol PartyServiceRepository {
    func createParty(_ party: Party, completion: @escaping (Result<Void, Error>) -> Void)
    func retrieveParty(_ key: String, completion: @escaping (Result<Party, Error>) -> Void)
    func retrieveAllParty(completion: @escaping (Result<[Party], Error>) -> Void)
    func retrieveMember(_ key: String, completion: @escaping (Result<Member, Error>) -> Void)
    func updateParty(_ party: Party, completion: @escaping (Result<Void, Error>) -> Void)
    func removeMember(_ key: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removeSpending(_ key: String, completion: @escaping (Result<Void, Error>) -> Void)
}
