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
        
        container.register(PartyViewModel.self) { resolver in
            let useCase = resolver.resolve(PartyUseCase.self)!
            return PartyViewModel(coordinator: coordinator, partyUseCase: useCase)
        }
        
        container.register(PartyMemberViewModel.self) { resolver in
            let useCase = resolver.resolve(PartyMemberUseCase.self)!
            return PartyMemberViewModel(coordinator: coordinator, partyMemberUseCase: useCase)
        }
        
        container.register(MainView.self) { resolver in
            let viewModel = resolver.resolve(MainViewModel.self)!
            return MainView(viewModel: viewModel)
        }
        
        container.register(PartyView.self) { resolver in
            let viewModel = resolver.resolve(PartyViewModel.self)!
            return PartyView(viewModel: viewModel)
        }
        
        container.register(PartyMemberView.self) { resolver in
            let viewModel = resolver.resolve(PartyMemberViewModel.self)!
            return PartyMemberView(viewModel: viewModel)
        }
        
    }
}
