//
//  PartyServiceRepository.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public protocol PartyServiceRepository {
    func retrievePartyList(_ completion: (Result<[PartyDTO], Error>) -> Void)
    func retrieveParty(id: String, _ completion: @escaping  (Result<PartyDTO, Error>) -> Void)
    func retrieveMember(id: String, _ completion: @escaping (Result<MemberDTO, Error>) -> Void)
    //func retrieveAllPartyList(_ completion: (Result<[PartyDTO], Error>) -> Void)
//    func retrieveSpending(_ completion: (Result<[SpendingDTO], Error>) -> Void)
   /* func createParty(_ request: PartyCreateDTO, completion: (Result<[PartyDTO], Error>) -> Void)
    func deleteParty(_ id: String, completion: (Result<[PartyDTO], Error>) -> Void)
    func updateParty(_ request: PartyUpdateDTO, completion: (Result<[PartyDTO], Error>) -> Void)*/
    
    func retrieveAllPartyList(_ completion: @escaping (Result<[PartyDTO], Error>) -> Void)
    func createParty(_ dto: PartyDTO, completion: @escaping (Result<[PartyDTO], Error>) -> Void)
    func updateParty(_ dto: PartyDTO, completion: @escaping () -> Void)
    func updateMember(_ dto: MemberDTO, completion: @escaping () -> Void)
    func removeMember(_ key: String, completion: @escaping () -> Void)
    func removeSpending(_ key: String, completion: @escaping () -> Void)
}
