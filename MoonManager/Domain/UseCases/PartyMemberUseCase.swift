//
//  PartyMemberUseCase.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public protocol PartyMemberUseCase {
    var spendings: AnyPublisher<[Spending], Never> { get }
    func fetchSpending()
}

public final class DefaultPartyMemberUseCase: PartyMemberUseCase {
    private let partyRepository: PartyServiceRepository
    private var spendingSubject = CurrentValueSubject<[Spending], Never>([])
    public var spendings: AnyPublisher<[Spending], Never> {
        return spendingSubject.eraseToAnyPublisher()
    }
    
    public init(partyRepository: PartyServiceRepository) {
        self.partyRepository = partyRepository
    }
    
    public func fetchSpending() {
        partyRepository.retrieveSpending { result in
            switch result {
            case .success(let data):
                spendingSubject.send(
                    data.map { Spending(DTO: $0) }
                )
            case .failure(let error):
                print(error)
            }
        }
    }
}
