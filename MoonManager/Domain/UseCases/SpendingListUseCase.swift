//
//  SpendingListUseCase.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 1/12/24.
//

import Combine
import Foundation

public protocol SpendingListUseCase {
    func getSpendingList(partyID id: String, completion: @escaping (Result<[Spending], Error>) -> Void)
    func removeSpending(spendingID id: String, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    public func getSpendingList(partyID id: String, completion: @escaping (Result<[Spending], Error>) -> Void) {
        partyRepository.retrieveParty(
            id,
            completion: { result in
                switch result {
                case .success(let party):
                    completion(.success(party.spendings))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func removeSpending(spendingID id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        partyRepository.removeSpending(id, completion: completion)
    }
}
