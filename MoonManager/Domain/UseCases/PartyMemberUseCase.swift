//
//  PartyMemberUseCase.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public protocol PartyMemberUseCase {
    var party: AnyPublisher<Party, Never> { get }
    var member: AnyPublisher<Member, Never> { get }
    var receipt: AnyPublisher<Receipt, Never> { get }
    func setup(partyID: String, memberID: String)
}

public final class DefaultPartyMemberUseCase: PartyMemberUseCase {
    private let partyRepository: PartyServiceRepository
    private var partySubject = PassthroughSubject<Party, Never>()
    private var memberSubject = PassthroughSubject<Member, Never>()
    private var receiptSubject = PassthroughSubject<Receipt, Never>()
    public var party: AnyPublisher<Party, Never> {
        return partySubject.eraseToAnyPublisher()
    }
    public var member: AnyPublisher<Member, Never> {
        return memberSubject.eraseToAnyPublisher()
    }
    public var receipt: AnyPublisher<Receipt, Never> {
        return receiptSubject.eraseToAnyPublisher()
    }
    
    public init(partyRepository: PartyServiceRepository) {
        self.partyRepository = partyRepository
    }
    
    public func setup(partyID: String, memberID: String) {
        fetchMember(memberID)
        fetchParty(partyID)
    }
    
    func fetchParty(_ partyID: String) {
        partyRepository.retrieveParty(id: partyID) { [weak self] result in
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
    
    func fetchMember(_ memberID: String) {
        partyRepository.retrieveMember(id: memberID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let member = Member(DTO: data)
                self.memberSubject.send(member)
            case .failure(let error):
                print(error)
            }
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
}
