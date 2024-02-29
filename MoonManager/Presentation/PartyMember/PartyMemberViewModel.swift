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
    
    var coordinator: CoordinatorProtocol
    
    @Published var member: Member
    @Published var party: Party
    @Published var receipt: Receipt
    @Published var spendingList: [Spending] = []
    @Published var paymentList: [Spending] = []
    @Published var totalCost: Int = 0
    @Published var saveScreenshot = false
    
    public init(
        party: Party,
        member: Member,
        receipt: Receipt,
        coordinator: CoordinatorProtocol
    ) {
        self.party = party
        self.member = member
        self.receipt = receipt
        self.coordinator = coordinator
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            self.commonInit()
        }
    }
}

extension PartyMemberViewModel {
    func commonInit() {
        self.spendingList = party.spendings.filter {
            $0.members.contains { $0.id == self.member.id }
        }
        self.paymentList = party.spendings.filter {
            $0.manager.id == self.member.id
        }
        self.totalCost = spendingList.reduce(0) {
            $0 + Int(ceil(Double($1.cost) / Double( $1.members.count)))
        }
    }
}
