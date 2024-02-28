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
        case onAppear(partyID: String, memberID: String)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var partyMemberUseCase: PartyMemberUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var member: Member = Member(id: "", name: "")
    @Published var party: Party? = nil
    @Published var receipt: Receipt? = nil
    @Published var spendingList: [Spending] = []
    @Published var paymentList: [Spending] = []
    @Published var totalCost: Int = 0
    @Published var saveScreenshot = false
    
    public init(coordinator: CoordinatorProtocol, partyMemberUseCase: PartyMemberUseCase) {
        self.coordinator = coordinator
        self.partyMemberUseCase = partyMemberUseCase
        self.binding()
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear(let partyID, let memberID):
            partyMemberUseCase.setup(partyID: partyID, memberID: memberID)
        }
    }
    
    func binding() {
        partyMemberUseCase.party
            .sink { [weak self] party in
                guard let self = self else { return }
                self.party = party
                let spendings = party.spendings
                
                var total: Int = 0
                var memberSpendings: [Spending] = []
                var memberPayments: [Spending] = []
                for spending in spendings {
                    let spend = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
                    
                    if spending.members.contains(where: { $0.id == self.member.id } ) {
                        memberSpendings.append(spending)
                        total += spend
                    }
                    
                    if spending.manager.id == self.member.id {
                        memberPayments.append(spending)
                    }
                }
                self.spendingList.removeAll()
                self.spendingList = memberSpendings
                self.paymentList.removeAll()
                self.paymentList = memberPayments
                
                totalCost = total
            }
            .store(in: &subscriptions)
        
        partyMemberUseCase.member
            .sink { [weak self] member in
                guard let self = self else { return }
                self.member = member
            }
            .store(in: &subscriptions)
        
        partyMemberUseCase.receipt
            .sink { [weak self] receipt in
                guard let self = self else { return }
                self.receipt = receipt
            }
            .store(in: &subscriptions)
    }
}
