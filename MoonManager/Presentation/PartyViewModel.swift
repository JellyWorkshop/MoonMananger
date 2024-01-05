//
//  PartyViewModel.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation
import Combine

class PartyViewModel: ObservableObject {
    let partyUseCase: PartyUseCase
    class Inputs {
        @Published var date: Date = .init()
    }
    
    
    
    init(partyUseCase: PartyUseCase) {
        self.partyUseCase = partyUseCase
    }
    
    
    
}
