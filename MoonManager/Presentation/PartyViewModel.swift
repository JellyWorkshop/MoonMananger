//
//  PartyViewModel.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public final class PartyViewModel: ViewModelable {
    enum Action {
        case onAppear
        case showMember(member: Member)
        case showSpendingList(id: String)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var partyUseCase: PartyUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var party: Party? = nil
    @Published var receipt: Receipt? = nil
    @Published var totalCost: Int = 0
    @Published var saveScreenshot = false
    
    public init(coordinator: CoordinatorProtocol, partyUseCase: PartyUseCase) {
        self.coordinator = coordinator
        self.partyUseCase = partyUseCase
        self.binding()
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            partyUseCase.fetchParty()
        case .showMember(let member):
            coordinator.push(.partyMember(member: member))
        case .showSpendingList(let id):
            coordinator.push(.spendingList(id: id))
        }
    }
    
    func binding() {
        partyUseCase.party
            .sink { [weak self] party in
                guard let self = self else { return }
                self.party = party
                guard let party = party else { return }
                let spendings = party.spendings
                
                var total: Int = 0
                for spending in spendings {
                    total += spending.cost
                }
                totalCost = total
                
                calculationTotalSpending(party: party)
            }
            .store(in: &subscriptions)
    }
    
    func calculationTotalSpending(party: Party) {
        var managers: [TotalSpending] = []
        
        for spending in party.spendings {
            let spend = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
            
            if managers.contains(where: { $0.manager.id == spending.manager.id }) {
                guard var manager = managers.filter({ $0.manager.id == spending.manager.id }).first else { return }
                let totalCost = manager.cost + spend
                manager.cost = totalCost
                managers = managers.filter{$0.manager.id != spending.manager.id }
                managers.append(manager)
            } else {
                managers.append(TotalSpending(id: UUID().uuidString, manager: spending.manager, cost: spend))
            }
        }
        
        if !managers.isEmpty, let manager: Member = managers.sorted(by: { $0.cost > $1.cost }).first?.manager {
            var totalMembers: [TotalMember] = []
            
            for member in party.members {
                for spending in party.spendings {
                    if spending.members.contains(where: { $0.id == member.id }) {
                        var spend: Int = 0
                        if spending.manager.id == member.id {
                            if spending.members.count > 1 {
                                let tempSpend = Int(ceil(Double(spending.cost) / Double(spending.members.count))) * (spending.members.count - 1)
                                spend = -tempSpend
                            } else {
                                spend = spending.cost
                            }
                        } else {
                            spend = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
                        }
                        
                        if member.id != manager.id {
                            if totalMembers.contains(where: { $0.member.id == member.id }) {
                                guard var tempMember = totalMembers.filter({ $0.member.id == member.id }).first else { return }
                                tempMember.cost = tempMember.cost + spend
                                var tempMembers = totalMembers.filter{$0.member.id != member.id }
                                tempMembers.append(tempMember)
                                totalMembers = tempMembers
                            } else {
                                totalMembers.append(TotalMember(id: UUID().uuidString, member: member, cost: spend))
                            }
                        }
                    }
                }
            }
            
            receipt = Receipt(id: UUID().uuidString, manager: manager, totalMember: totalMembers)
        }
    }
}
