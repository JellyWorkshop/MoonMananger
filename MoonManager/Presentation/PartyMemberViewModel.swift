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
        case onAppear
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var partyMemberUseCase: PartyMemberUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var member: Member = Member(id: "", name: "")
    @Published var spendings: [Spending] = []
    @Published var spendingList: [Spending] = []
    @Published var paymentList: [Spending] = []
    @Published var totalSpending: Int = 0
    @Published var totalSpendingList: [TotalSpending] = []
    
    
    public init(coordinator: CoordinatorProtocol, partyMemberUseCase: PartyMemberUseCase) {
        self.coordinator = coordinator
        self.partyMemberUseCase = partyMemberUseCase
        self.binding()
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            partyMemberUseCase.fetchSpendings()
        }
    }
    
    func binding() {
        partyMemberUseCase.spendings
            .sink { [weak self] spendings in
                guard let self = self else { return }
                self.spendings = spendings
                
                var memberslist: [Spending] = []
                spendings.forEach { spending in
                    if spending.members.contains(where: { $0.id == self.member.id }) {
                        memberslist.append(spending)
                    }
                }
                self.spendingList = memberslist
                
                var totalAmount: Int = 0
                var totalList: [TotalSpending] = []
                memberslist.forEach { spending in
                    let spend = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
                    totalAmount += spend
                    
                    if self.member.id != spending.manager.id {
                        if totalList.contains(where: { $0.manager.id == spending.manager.id }) {
                            guard var totalSpending = totalList.filter({ $0.manager.id == spending.manager.id }).first else { return }
                            let totalCost = totalSpending.cost + spend
                            totalSpending.cost = totalCost
                            totalList = totalList.filter{$0.manager.id != spending.manager.id }
                            totalList.append(totalSpending)
                        } else {
                            totalList.append(TotalSpending(id: UUID().uuidString, manager: spending.manager, cost: spend))
                        }
                    }
                    
                }
                self.totalSpending = totalAmount
                self.totalSpendingList = totalList.sorted(by: { $0.cost < $1.cost })
                
                var managerList: [Spending] = []
                spendings.forEach { spending in
                    if spending.manager.id == self.member.id {
                        managerList.append(spending)
                    }
                }
                self.paymentList = managerList
                
                self.member = Member(DTO: Mock.member1)
            }
            .store(in: &subscriptions)
    }
}
