//
//  PartyMemberUseCase.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public protocol PartyMemberUseCase {
    func fetchParty(_ key: String, completion: @escaping (Result<Party, Error>) -> Void)
    func fetchMember(_ key: String, completion: @escaping (Result<Member, Error>) -> Void)
}

public final class DefaultPartyMemberUseCase: PartyMemberUseCase {

    private let partyRepository: PartyServiceRepository

    public init(
        partyRepository: PartyServiceRepository
    ) {
        self.partyRepository = partyRepository
    }

    public func fetchParty(_ key: String, completion: @escaping (Result<Party, Error>) -> Void) {
        partyRepository.retrieveParty(key, completion: completion)
    }
    
    public func fetchMember(_ key: String, completion: @escaping (Result<Member, Error>) -> Void) {
        partyRepository.retrieveMember(key, completion: completion)
    }
}
