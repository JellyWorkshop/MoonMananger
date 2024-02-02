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
        case onAppear
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var spendingListUseCase: SpendingListUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var party: Party? = nil
    @Published var spendings: [Spending] = []
    
    public init(coordinator: CoordinatorProtocol, spendingListUseCase: SpendingListUseCase) {
        self.coordinator = coordinator
        self.spendingListUseCase = spendingListUseCase
        self.binding()
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            spendingListUseCase.fetchParty()
        }
    }
    
    func binding() {
        spendingListUseCase.party
            .sink { [weak self] party in
                guard let self = self else { return }
                self.party = party
            }
            .store(in: &subscriptions)
        
        spendingListUseCase.spendings
            .sink { [weak self] spendings in
                guard let self = self else { return }
                self.spendings = spendings
            }
            .store(in: &subscriptions)
    }
}
