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
        case onAppear
        case showParty(id: String)
        case createParty(party: Party)
    }
        
    private var subscriptions = Set<AnyCancellable>()
    private var mainUseCase: MainUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var partyList: [Party] = []
    
    public init(coordinator: CoordinatorProtocol, mainUseCase: MainUseCase) {
        self.coordinator = coordinator
        self.mainUseCase = mainUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            self.getParty()
        case .showParty(let id):
            coordinator.push(.party(id: id))
        case .createParty(let party):
            self.addParty(party: party)
        }
    }
}

extension MainViewModel {
    func getParty() {
        mainUseCase.fetchPartyList { result in
            switch result {
            case .success(let list):
                self.partyList = list
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addParty(party: Party) {
        mainUseCase.createParty(party) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
