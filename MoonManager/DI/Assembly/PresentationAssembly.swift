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
        
        container.register(PartyView.self) { resolver in
            return PartyView()
        }
        
        container.register(PartyMemberView.self) { resolver in
            return PartyMemberView()
        }
        
    }
}
