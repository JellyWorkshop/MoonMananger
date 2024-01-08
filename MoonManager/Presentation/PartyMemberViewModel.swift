//
//  PartyMemberViewModel.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public final class PartyMemberViewModel: ViewModelable {
    enum Action {
        case onApear
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var partyMemberUseCase: PartyMemberUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var spendings: [Spending] = []
    @Published var spendingList: [Spending] = []
    @Published var paymentList: [Spending] = []
    @Published var totalSpending: Int = 0
    
    public init(coordinator: CoordinatorProtocol, partyMemberUseCase: PartyMemberUseCase) {
        self.coordinator = coordinator
        self.partyMemberUseCase = partyMemberUseCase
        self.binding()
    }
    
    func action(_ action: Action) {
        switch action {
        case .onApear:
            partyMemberUseCase.fetchSpending()
        }
    }
    
    func binding() {
        partyMemberUseCase.spendings
            .sink { [weak self] spendings in
                guard let self = self else { return }
                self.spendings = spendings
                
                var memberslist: [Spending] = []
                spendings.forEach { spending in
                    if spending.members.contains(where: { $0.id == "1" }) {
                        memberslist.append(spending)
                    }
                }
                self.spendingList = memberslist
                
                var totalAmount: Double = 0.0
                memberslist.forEach { spending in
                    let spend = spending.cost / spending.members.count
                    totalAmount += Double(spend)
                }
                
                self.totalSpending = Int(totalAmount)
                
                var managerList: [Spending] = []
                spendings.forEach { spending in
                    if spending.manager.id == "1" {
                        managerList.append(spending)
                    }
                }
                self.paymentList = managerList
            }
            .store(in: &subscriptions)
    }
}
