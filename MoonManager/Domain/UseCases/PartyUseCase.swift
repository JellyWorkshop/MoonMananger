//
//  PartyUseCase.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public protocol PartyUseCase {
    var party: AnyPublisher<Party?, Never> { get }
    func fetchParty()
}

public final class DefaultPartyUseCase: PartyUseCase {
    private let partyRepository: PartyServiceRepository
    private var partySubject = CurrentValueSubject<Party?, Never>(nil)
    public var party: AnyPublisher<Party?, Never> {
        return partySubject.eraseToAnyPublisher()
    }
    
    public init(partyRepository: PartyServiceRepository) {
        self.partyRepository = partyRepository
    }
    
    public func fetchParty() {
        partyRepository.retrieveParty { result in
            switch result {
            case .success(let data):
                partySubject.send(Party(DTO: data))
            case .failure(let error):
                print(error)
            }
        }
    }
}
