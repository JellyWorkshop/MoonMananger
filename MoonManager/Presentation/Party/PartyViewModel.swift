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
        case showMember(member: Member)
        case showSpendingList(id: String)
        case addMember(name: String)
        case updateMember(member: Member)
        case removeMember(member: Member)
        case addSpending(title: String, cost: Int, manager: Member, excludeMembers: [Member])
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var partyUseCase: PartyUseCase
    var coordinator: CoordinatorProtocol
    
    @Published var party: Party?
    @Published var receipt: Receipt?
    @Published var totalCost: Int = 0
    @Published var saveScreenshot = false
    
    public init(coordinator: CoordinatorProtocol, partyUseCase: PartyUseCase) {
        self.coordinator = coordinator
        self.partyUseCase = partyUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear(let id):
            self.fetchParty(id: id)
        case .showMember(let member):
            guard let party = party,
                  let receipt = receipt else { return }
            coordinator.push(
                .partyMember(
                    party: party,
                    member: member,
                    receipt: receipt
                )
            )
        case .showSpendingList(let id):
            coordinator.push(.spendingList(id: id))
        case .addMember(let name):
            self.addMemeber(name)
        case .updateMember(let member):
            break
        case .removeMember(let member):
            self.removeMember(member)
        case .addSpending(let title, let cost, let manager, let excludeMembers):
            self.addSpending(title: title, cost: cost, manager: manager, excludeMembers: excludeMembers)
        }
    }
}

extension PartyViewModel {
    func fetchParty(id: String) {
        partyUseCase.fetchParty(
            id,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let party):
                    self.party = party
                    let spendings = party.spendings
                    
                    var total: Int = 0
                    for spending in spendings {
                        total += spending.cost
                    }
                    self.totalCost = total
                    self.receipt = getTotalReceipt(party: party)
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
    
    func addMemeber(_ name: String) {
        if var party = party {
            party.members.append(Member(name: name))
            partyUseCase.updateParty(
                party,
                completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.fetchParty(id: party.id)
                    case .failure(let error):
                        print(error)
                    }
                }
            )
        }
    }
    
    func removeMember(_ member: Member) {
        self.partyUseCase.removeMember(
            member.id,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    print("### removeMember")
                    if let party = self.party {
                        for spending in party.spendings where spending.manager.id == member.id{
                            self.removeSpending(spending)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
    
    func removeSpending(_ spending: Spending) {
        self.partyUseCase.removeSpending(
            spending.id,
            completion: { result in
                switch result {
                case .success:
                    print("### removeSpending")
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
    
    func addSpending(title: String, cost: Int, manager: Member, excludeMembers: [Member]) {
        if var party = party {
            var members: [Member] = party.members
            for member in excludeMembers {
                members = members.filter{ $0.id != member.id }
            }
            
            party.spendings.append(
                Spending(
                    title: title,
                    cost: cost,
                    manager: manager,
                    members: members
                )
            )
            partyUseCase.updateParty(
                party,
                completion: { result in
                    switch result {
                    case .success(let success):
                        print("success updateParty")
                    case .failure(let error):
                        print(error)
                    }
                }
            )
        }
    }
    
    func getTotalReceipt(party: Party) -> Receipt?{
        var totalMembers: [TotalMember] = []
        for member in party.members {
            let memberSpendings = party.spendings
                .filter{ $0.members.contains{ $0.id == member.id }}
            
            let totalCost: Int = memberSpendings
                .map { spending in
                    let spend = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
                    let num = spending.members.count - 1
                    return spending.manager.id == member.id ? -(spend * num) : spend
                }
                .reduce(0) { $0 + $1 }
            
            totalMembers.append(
                TotalMember(
                    id: UUID().uuidString,
                    member: member,
                    cost: totalCost,
                    direction: totalCost > 0 ? .send : .refund
                )
            )
        }
        
        if !totalMembers.isEmpty, 
            let manager = totalMembers.max(by: { $0.cost > $1.cost }) {
            totalMembers = totalMembers.filter { $0.id != manager.id }
            return Receipt(
                id: UUID().uuidString,
                manager: manager.member,
                totalMember: totalMembers
            )
        } else {
            return nil
        }
    }
    
    /*
    private func calculate(party: Party) -> TotalReceipt {
        var receipts: [Receipts] = party.members.map { member in
            /// 참여한 지출건
            let joinedSpending = party.spendings.filter { spending in
                spending.members.contains { $0.id == member.id }
            }

            /// 지불해야할 금액 = 평균 총합
            /// 평균 = 지출금 / 인원수
            let shouldPaidAmount: Int = joinedSpending
                .map { spending in
                    spending.cost / spending.members.count
                }.reduce(0) { $0 + $1 }

            /// 지불한 금액
            let paidForAmount: Int = joinedSpending
                .filter { $0.manager.id == member.id }
                .reduce(0) { $0 + $1.cost }

            return Receipts(
                settler: member,
                joined: joinedSpending,
                shouldPaidAmount: shouldPaidAmount,
                paidForAmount: paidForAmount,
                directions: []
            )
        }
        // 제일 많이 지불한 총무
        var manager = receipts.max { $0.paidForAmount < $1.paidForAmount }!
        receipts = receipts.filter { $0.settler.id != manager.settler.id }
            .map { receipt in
                var receipt = receipt
                // 정산할금액 = 지불한 금액 - 지불해야할 금액
                let total = receipt.paidForAmount - receipt.shouldPaidAmount
                // 정산할 금액이 양수 -> 환급 받야야함
                // 정산할 금액이 음수 -> 총무에게 송금
                if total > 0 {
                    receipt.directions = [
                        SettlementDirection(
                            type: .refund,
                            from: manager.settler ,
                            to: receipt.settler,
                            ammount: abs(total)
                        )
                    ]
                } else if total < 0 {
                    receipt.directions = [
                        SettlementDirection(
                            type: .send,
                            from: receipt.settler ,
                            to: manager.settler,
                            ammount: abs(total)
                        )
                    ]
                }
                return receipt
            }

        // 환급 받은 정산 방향만 저장
        manager.directions = receipts
            .filter { $0.directions.contains { $0.type == .refund } }
            .flatMap { $0.directions }

        // 다시 영수증에 집어 넣음
        // 원래 순서대로 정렬
        receipts.append(manager)

        return TotalReceipt(
            manager: manager.settler,
            spending: party.spendings,
            receipts: receipts
        )
    }*/
}
