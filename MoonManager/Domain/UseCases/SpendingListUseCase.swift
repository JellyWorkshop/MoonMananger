//
//  SpendingListUseCase.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 1/12/24.
//

import Combine
import Foundation

public protocol SpendingListUseCase {
    var spendings: AnyPublisher<[Spending], Never> { get }
    func fetchParty(_ partyID: String)
    func removeSpending(partyID: String, spendingID: String)
}

public final class DefaultSpendingListUseCase: SpendingListUseCase {
    private let partyRepository: PartyServiceRepository
    private var spendingSubject = CurrentValueSubject<[Spending], Never>([])
    public var spendings: AnyPublisher<[Spending], Never> {
        return spendingSubject.eraseToAnyPublisher()
    }
    
    public init(partyRepository: PartyServiceRepository) {
        self.partyRepository = partyRepository
    }
    
    public func fetchParty(_ partyID: String) {
        partyRepository.retrieveParty(id: partyID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let party = Party(DTO: data)
                self.spendingSubject.send(party.spendings)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func removeSpending(partyID: String, spendingID: String) {
        self.partyRepository.removeSpending(spendingID) {
            self.fetchParty(partyID)
        }
    }
}
