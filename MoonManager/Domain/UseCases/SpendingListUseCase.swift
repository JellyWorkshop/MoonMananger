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
    func fetchSpendings()
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
    
    public func fetchSpendings() {
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
