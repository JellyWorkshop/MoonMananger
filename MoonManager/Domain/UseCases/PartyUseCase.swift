//
//  PartyUseCase.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public protocol PartyUseCase {
    func fetchParty(_ key: String, completion: @escaping (Result<Party, Error>) -> Void)
    func updateParty(_ party: Party, completion: @escaping (Result<Void, Error>) -> Void)
    func removeMember(_ id: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removeSpending(_ id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

public final class DefaultPartyUseCase: PartyUseCase {
    private let partyRepository: PartyServiceRepository
  
    public init(partyRepository: PartyServiceRepository) {
        self.partyRepository = partyRepository
    }
    
    public func fetchParty(_ key: String, completion: @escaping (Result<Party, Error>) -> Void) {
        partyRepository.retrieveParty(key, completion: completion)
    }
    
    public func updateParty(_ party: Party, completion: @escaping (Result<Void, Error>) -> Void) {
        partyRepository.updateParty(party, completion: completion)
    }
    
    public func updateMember(_ member: Member, completion: @escaping (Result<Void, Error>) -> Void) {
        let dto = MemberDTO(id: member.id, name: member.name)
        
    }
    
    public func removeMember(_ id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        partyRepository.removeMember(id, completion: completion)
    }
    
    public func removeSpending(_ id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        partyRepository.removeSpending(id, completion: completion)
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
}
