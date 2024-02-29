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
        
        container.register(PartyMemberViewModel.self) { resolver, party, member, receipt in
            return PartyMemberViewModel(
                party: party,
                member: member,
                receipt: receipt,
                coordinator: coordinator
            )
        }
        .inObjectScope(.graph)
        
        container.register(PartyMemberView.self) { resolver, party, member, receipt in
            let party: Party = party
            let member: Member = member
            let receipt: Receipt = receipt
            let viewModel = resolver.resolve(
                PartyMemberViewModel.self,
                arguments: party, member, receipt
            )!
            return PartyMemberView(viewModel: viewModel)
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
