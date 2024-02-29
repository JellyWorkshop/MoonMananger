//
//  MainUseCase.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public protocol MainUseCase {
    func fetchPartyList(_ completion: @escaping (Result<[Party], Error>) -> Void)
    func createParty(_ party: Party, completion: @escaping (Result<Void, Error>) -> Void)
}

public final class DefaultMainUseCase: MainUseCase {
    private let partyRepository: PartyServiceRepository

    public init(partyRepository: PartyServiceRepository) {
        self.partyRepository = partyRepository
    }
    
    public func fetchPartyList(_ completion: @escaping (Result<[Party], Error>) -> Void) {
        partyRepository.retrieveAllParty(completion: completion)
    }
    
    public func createParty(_ party: Party, completion: @escaping (Result<Void, Error>) -> Void) {
        partyRepository.createParty(party, completion: completion)
    }
}
