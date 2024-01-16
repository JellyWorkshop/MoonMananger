//
//  PartyViewModel.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public final class PartyViewModel: ViewModelable {
    enum Action {
        case onAppear
        case showMember(id: String)
        case showSpendingList(id: String)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var partyUseCase: PartyUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var party: Party? = nil
    @Published var totalCost: Int = 0
    
    public init(coordinator: CoordinatorProtocol, partyUseCase: PartyUseCase) {
        self.coordinator = coordinator
        self.partyUseCase = partyUseCase
        self.binding()
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            partyUseCase.fetchParty()
        case .showMember(let id):
            coordinator.push(.partyMember(id: id))
        case .showSpendingList(let id):
            coordinator.push(.spendingList(id: id))
        }
    }
    
    func binding() {
        partyUseCase.party
            .sink { [weak self] party in
                guard let self = self else { return }
                self.party = party
                
                guard let spendings = party?.spendings else { return }
                
                var total: Int = 0
                for spending in spendings {
                    total += spending.cost
                }
                totalCost = total
            }
            .store(in: &subscriptions)
    }
}
