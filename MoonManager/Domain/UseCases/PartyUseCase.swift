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
    var receipt: AnyPublisher<TotalReceipt, Never> { get }
    func fetchParty()
}

public final class DefaultPartyUseCase: PartyUseCase {
    private let partyRepository: PartyServiceRepository
    private var partySubject = PassthroughSubject<Party, Never>()
    private var receiptSubject = PassthroughSubject<TotalReceipt, Never>()
    private var subscriptions = Set<AnyCancellable>()
    public var party: AnyPublisher<Party, Never> {
        return partySubject
            .eraseToAnyPublisher()
    }
    public var receipt: AnyPublisher<TotalReceipt, Never> {
        return receiptSubject
            .eraseToAnyPublisher()
    }
    
    public init(partyRepository: PartyServiceRepository) {
        self.partyRepository = partyRepository
        partySubject
            .map { self.calculate(party: $0) }
            .sink(receiveValue: {  receipt in
                self.receiptSubject.send(receipt)
            })
            .store(in: &subscriptions)
    }
    
    public func fetchParty() {
        partyRepository.retrieveParty { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let party = Party(DTO: data)
                self.partySubject.send(party)
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
    }
}
