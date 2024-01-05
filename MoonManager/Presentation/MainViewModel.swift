//
//  MainViewModel.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public final class MainViewModel: ViewModelable {
    enum Action {
        case onApear
        case showParty(id: String)
    }
        
    private var subscriptions = Set<AnyCancellable>()
    private var mainUseCase: MainUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var partyList: [Party] = []
    
    public init(coordinator: CoordinatorProtocol, mainUseCase: MainUseCase) {
        self.coordinator = coordinator
        self.mainUseCase = mainUseCase
        self.binding()
    }
    
    func action(_ action: Action) {
        switch action {
        case .onApear:
            mainUseCase.fetchPartyList()
        case .showParty(let id):
            coordinator.push(.party(id: id))
        }
    }
    
    func binding() {
        mainUseCase.partyList
            .sink { [weak self] partyList in
                guard let self = self else { return }
                self.partyList = partyList
            }
            .store(in: &subscriptions)
    }
}
