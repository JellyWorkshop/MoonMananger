//
//  PartyUseCase.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public protocol PartyUseCase {
    var party: AnyPublisher<Party, Never> { get }
    var receipt: AnyPublisher<Receipt, Never> { get }
    func fetchParty(id: String)
    func updateParty(_ party: Party)
    func updateMember(_ member: Member)
    func removeMember(party: Party, member: Member)
}

public final class DefaultPartyUseCase: PartyUseCase {
    private let partyRepository: PartyServiceRepository
    private var partySubject = PassthroughSubject<Party, Never>()
    private var receiptSubject = PassthroughSubject<Receipt, Never>()
    private var subscriptions = Set<AnyCancellable>()
    public var party: AnyPublisher<Party, Never> {
        return partySubject.eraseToAnyPublisher()
    }
    public var receipt: AnyPublisher<Receipt, Never> {
        return receiptSubject.eraseToAnyPublisher()
    }
    
    public init(partyRepository: PartyServiceRepository) {
        self.partyRepository = partyRepository
    }
    
    public func fetchParty(id: String) {
        partyRepository.retrieveParty(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let party = Party(DTO: data)
                self.partySubject.send(party)
                self.calculationTotalReceipt(party: party)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func updateParty(_ party: Party) {
        let dto = PartyDTO(id: party.id, name: party.name, members: party.members.map{ MemberDTO(id: $0.id, name: $0.name) }, spendings: party.spendings.map{ SpendingDTO(id: $0.id, title: $0.title, cost: $0.cost, manager: MemberDTO(id: $0.manager.id, name: $0.manager.name), members: $0.members.map{ MemberDTO(id: $0.id, name: $0.name) }) }, image: party.image)
        partyRepository.updateParty(dto) {
            self.fetchParty(id: party.id)
        }
    }
    
    public func updateMember(_ member: Member) {
        let dto = MemberDTO(id: member.id, name: member.name)
    }
    
    public func removeMember(party: Party, member: Member) {
        self.partyRepository.removeMember(member.id) {
            print("### removeMember")
            for spending in party.spendings {
                if spending.manager.id == member.id {
                    self.partyRepository.removeSpending(spending.id) {
                        print("### removeSpending")
                    }
                }
            }
            self.fetchParty(id: party.id)
        }
    }
    
    func calculationTotalReceipt(party: Party) {
        var totalMembers: [TotalMember] = []
        
        for member in party.members {
            let memberSpendings = party.spendings.filter{ $0.members.contains{ $0.id == member.id }}
            
            let totalCost: Int = memberSpendings
                .map { spending in
                    let spend = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
                    let num = spending.members.count - 1
                    
                    return spending.manager.id == member.id ? -(spend * num) : spend
                }
                .reduce(0) { $0 + $1 }
            
            totalMembers.append(TotalMember(id: UUID().uuidString, member: member, cost: totalCost, direction: totalCost > 0 ? .send : .refund))
        }
        
        if !totalMembers.isEmpty, let manager = totalMembers.max(by: { $0.cost > $1.cost }) {
            totalMembers = totalMembers.filter { $0.id != manager.id }
            let receipt = Receipt(id: UUID().uuidString, manager: manager.member, totalMember: totalMembers)
            
            self.receiptSubject.send(receipt)
        }
    }
    
//    func calculationTotalSpending(party: Party) {
//        var managers: [TotalSpending] = []
//        
//        for spending in party.spendings {
//            let spend = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
//            
//            if managers.contains(where: { $0.manager.id == spending.manager.id }) {
//                guard var manager = managers.filter({ $0.manager.id == spending.manager.id }).first else { return }
//                let totalCost = manager.cost + spend
//                manager.cost = totalCost
//                managers = managers.filter{$0.manager.id != spending.manager.id }
//                managers.append(manager)
//            } else {
//                managers.append(TotalSpending(id: UUID().uuidString, manager: spending.manager, cost: spend))
//            }
//        }
//        
//        
//        
//        if !managers.isEmpty, let manager: Member = managers.sorted(by: { $0.cost > $1.cost }).first?.manager {
//            var totalMembers: [TotalMember] = []
//            
//            for member in party.members {
//                for spending in party.spendings {
//                    if spending.members.contains(where: { $0.id == member.id }) {
//                        var spend: Int = 0
//                        if spending.manager.id == member.id {
//                            if spending.members.count > 1 {
//                                let tempSpend = Int(ceil(Double(spending.cost) / Double(spending.members.count))) * (spending.members.count - 1)
//                                spend = -tempSpend
//                            } else {
//                                spend = spending.cost
//                            }
//                        } else {
//                            spend = Int(ceil(Double(spending.cost) / Double(spending.members.count)))
//                        }
//                        
//                        if member.id != manager.id {
//                            if totalMembers.contains(where: { $0.member.id == member.id }) {
//                                guard var tempMember = totalMembers.filter({ $0.member.id == member.id }).first else { return }
//                                tempMember.cost = tempMember.cost + spend
//                                var tempMembers = totalMembers.filter{$0.member.id != member.id }
//                                tempMembers.append(tempMember)
//                                totalMembers = tempMembers
//                            } else {
//                                totalMembers.append(TotalMember(id: UUID().uuidString, member: member, cost: spend))
//                            }
//                        }
//                    }
//                }
//            }
//            
//            receipt = Receipt(id: UUID().uuidString, manager: manager, totalMember: totalMembers)
//        }
//    }
//    
//    
//    private func calculate(party: Party) -> TotalReceipt {
//        var receipts: [Receipts] = party.members.map { member in
//            /// 참여한 지출건
//            let joinedSpending = party.spendings.filter { spending in
//                spending.members.contains { $0.id == member.id }
//            }
//            
//            /// 지불해야할 금액 = 평균 총합
//            /// 평균 = 지출금 / 인원수
//            let shouldPaidAmount: Int = joinedSpending
//                .map { spending in
//                    spending.cost / spending.members.count
//                }.reduce(0) { $0 + $1 }
//            
//            /// 지불한 금액
//            let paidForAmount: Int = joinedSpending
//                .filter { $0.manager.id == member.id }
//                .reduce(0) { $0 + $1.cost }
//            
//            return Receipts(
//                settler: member,
//                joined: joinedSpending,
//                shouldPaidAmount: shouldPaidAmount,
//                paidForAmount: paidForAmount,
//                directions: []
//            )
//        }
//        // 제일 많이 지불한 총무
//        var manager = receipts.max { $0.paidForAmount < $1.paidForAmount }!
//        receipts = receipts.filter { $0.settler.id != manager.settler.id }
//            .map { receipt in
//                var receipt = receipt
//                // 정산할금액 = 지불한 금액 - 지불해야할 금액
//                let total = receipt.paidForAmount - receipt.shouldPaidAmount
//                // 정산할 금액이 양수 -> 환급 받야야함
//                // 정산할 금액이 음수 -> 총무에게 송금
//                if total > 0 {
//                    receipt.directions = [
//                        SettlementDirection(
//                            type: .refund,
//                            from: manager.settler ,
//                            to: receipt.settler,
//                            ammount: abs(total)
//                        )
//                    ]
//                } else if total < 0 {
//                    receipt.directions = [
//                        SettlementDirection(
//                            type: .send,
//                            from: receipt.settler ,
//                            to: manager.settler,
//                            ammount: abs(total)
//                        )
//                    ]
//                }
//                return receipt
//            }
//        
//        // 환급 받은 정산 방향만 저장
//        manager.directions = receipts
//            .filter { $0.directions.contains { $0.type == .refund } }
//            .flatMap { $0.directions }
//        
//        // 다시 영수증에 집어 넣음
//        // 원래 순서대로 정렬
//        receipts.append(manager)
//        
//        return TotalReceipt(
//            manager: manager.settler,
//            spending: party.spendings,
//            receipts: receipts
//        )
//    }
}
