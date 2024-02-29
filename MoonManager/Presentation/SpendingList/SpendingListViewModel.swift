//
//  SpendingListViewModel.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 1/12/24.
//

import Combine
import Foundation

public final class SpendingListViewModel: ViewModelable {
    enum Action {
        case onAppear(_ id: String)
        case removeSpending(partyID: String, spending: Spending)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var spendingListUseCase: SpendingListUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var spendings: [Spending] = []
    
    public init(coordinator: CoordinatorProtocol, spendingListUseCase: SpendingListUseCase) {
        self.coordinator = coordinator
        self.spendingListUseCase = spendingListUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear(let id):
            getSpendingList(partyID: id)
        case .removeSpending(let partyID, let spending):
            removeSpending(paryID: partyID, spendingID: spending.id)
        }
    }
}

extension SpendingListViewModel {
    func getSpendingList(partyID: String) {
        spendingListUseCase.getSpendingList(
            partyID: partyID,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let spendings):
                    self.spendings = spendings
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
    
    func removeSpending(paryID: String, spendingID: String) {
        spendingListUseCase.removeSpending(
            spendingID: spendingID,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.getSpendingList(partyID: paryID)
                    print("success removeSpending")
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
}
