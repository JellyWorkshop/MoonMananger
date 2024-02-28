//
//  PresentationAssembly.swift
//  MoonManager
//
//  Created by cschoi on 1/4/24.
//

import Foundation
import Swinject

public struct PresentationAssembly: Assembly {
    
    weak var coordinator: Coordinator!
    
    public func assemble(container: Container) {
        container.register(MainViewModel.self) { resolver in
            let useCase = resolver.resolve(MainUseCase.self)!
            return MainViewModel(coordinator: coordinator, mainUseCase: useCase)
        }

        container.register(MainView.self) { resolver in
            let viewModel = resolver.resolve(MainViewModel.self)!
            return MainView(viewModel: viewModel)
        }
        
        container.register(PartyViewModel.self) { resolver in
            let useCase = resolver.resolve(PartyUseCase.self)!
            return PartyViewModel(coordinator: coordinator, partyUseCase: useCase)
        }
        .inObjectScope(.graph)
        
        container.register(PartyView.self) { resolver, id in
            let viewModel = resolver.resolve(PartyViewModel.self)!
            return PartyView(viewModel: viewModel, id: id)
        }
        .inObjectScope(.graph)
        
        container.register(PartyMemberViewModel.self) { resolver in
            let useCase = resolver.resolve(PartyMemberUseCase.self)!
            return PartyMemberViewModel(coordinator: coordinator, partyMemberUseCase: useCase)
        }
        .inObjectScope(.graph)
        
        container.register(PartyMemberView.self) { resolver, data in
            let data: (String, String) = data
            let viewModel = resolver.resolve(PartyMemberViewModel.self)!
            return PartyMemberView(viewModel: viewModel, partyID: data.0, memberID: data.1)
        }
        .inObjectScope(.graph)
        
        container.register(SpendingListViewModel.self) { resolver in
            let useCase = resolver.resolve(SpendingListUseCase.self)!
            return SpendingListViewModel(coordinator: coordinator, spendingListUseCase: useCase)
        }
        .inObjectScope(.graph)
        
        container.register(SpendingListView.self) { resolver, id in
            let viewModel = resolver.resolve(SpendingListViewModel.self)!
            return SpendingListView(viewModel: viewModel, id: id)
        }
        .inObjectScope(.graph)
    }
}
