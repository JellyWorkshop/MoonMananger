//
//  PartyServiceRepository.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

public protocol PartyServiceRepository {
    func retrievePartyList(_ completion: (Result<[PartyDTO], Error>) -> Void)
    func createParty(_ request: PartyCreateDTO, completion: (Result<[PartyDTO], Error>) -> Void)
    func deleteParty(_ id: String, completion: (Result<[PartyDTO], Error>) -> Void)
    func updateParty(_ request: PartyUpdateDTO, completion: (Result<[PartyDTO], Error>) -> Void)
}
