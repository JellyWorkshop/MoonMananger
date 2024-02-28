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
        case onAppear(id: String)
        case showMember(partyID: String, memberID: String)
        case showSpendingList(id: String)
        case addMember(name: String)
        case updateMember(member: Member)
        case removeMember(member: Member)
        case addSpending(title: String, cost: Int, manager: Member, excludeMembers: [Member])
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
        case .onAppear(let id):
            partyUseCase.fetchParty(id: id)
        case .showMember(let partyID, let memberID):
            coordinator.push(.partyMember(partyID: partyID, memberID: memberID))
        case .showSpendingList(let id):
            coordinator.push(.spendingList(id: id))
        case .addMember(let name):
            if var tempParty = party {
                tempParty.members.append(Member(name: name))
                partyUseCase.updateParty(tempParty)
            }
        case .updateMember(let member):
            break
        case .removeMember(let member):
            if let party = party {
                partyUseCase.removeMember(party: party, member: member)
            }
        case .addSpending(let title, let cost, let manager, let excludeMembers):
            if var tempParty = party {
                
                var members: [Member] = tempParty.members
                for member in excludeMembers {
                    members = members.filter{ $0.id != member.id }
                }
                
                tempParty.spendings.append((Spending(title: title, cost: cost, manager: manager, members: members)))
                partyUseCase.updateParty(tempParty)
            }
        }
    }
    
    func binding() {
        partyUseCase.party
            .sink { [weak self] party in
                guard let self = self else { return }
                self.party = party
                let spendings = party.spendings
                
                var total: Int = 0
                for spending in spendings {
                    total += spending.cost
                }
                totalCost = total
            }
            .store(in: &subscriptions)
        
        partyUseCase.receipt
            .sink { [weak self] receipt in
                guard let self = self else { return }
                self.receipt = receipt
            }
            .store(in: &subscriptions)
    }
}
