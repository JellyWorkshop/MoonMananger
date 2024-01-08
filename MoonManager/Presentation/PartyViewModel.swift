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
        case onApear
        case showMember(id: String)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var partyUseCase: PartyUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var party: Party? = nil
    
    public init(coordinator: CoordinatorProtocol, partyUseCase: PartyUseCase) {
        self.coordinator = coordinator
        self.partyUseCase = partyUseCase
        self.binding()
    }
    
    func action(_ action: Action) {
        switch action {
        case .onApear:
            partyUseCase.fetchParty()
        case .showMember(let id):
            coordinator.push(.partyMember(id: id))
        }
    }
    
    func binding() {
        partyUseCase.party
            .sink { [weak self] party in
                guard let self = self else { return }
                self.party = party
            }
            .store(in: &subscriptions)
    }
}
