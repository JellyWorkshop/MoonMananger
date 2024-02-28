//
//  MainUseCase.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Combine
import Foundation

public protocol MainUseCase {
    var partyList: AnyPublisher<[Party], Never> { get }
    func fetchPartyList()
    func createParty(_ party: Party)
}

public final class DefaultMainUseCase: MainUseCase {
    private let partyRepository: PartyServiceRepository
    private var partySubject = CurrentValueSubject<[Party], Never>([])
    public var partyList: AnyPublisher<[Party], Never> {
        return partySubject.eraseToAnyPublisher()
    }
    
    public init(partyRepository: PartyServiceRepository) {
        self.partyRepository = partyRepository
    }
    
    public func fetchPartyList(){
        partyRepository.retrieveAllPartyList { result in
            switch result {
            case .success(let data):
                self.partySubject.send(
                    data.map{ Party(DTO: $0) }
                )
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func createParty(_ party: Party) {
        let dto = PartyDTO(id: party.id, name: party.name, members: party.members.map{ MemberDTO(id: $0.id, name: $0.name) }, spendings: party.spendings.map{ SpendingDTO(id: $0.id, title: $0.title, cost: $0.cost, manager: MemberDTO(id: $0.manager.id, name: $0.manager.name), members: $0.members.map{ MemberDTO(id: $0.id, name: $0.name) }) }, image: party.image)
        partyRepository.createParty(dto) { result in
//            switch result {
//            case .success(let success):
//                self.partyRepository.retrieveAllPartyList { result in
//                    switch result {
//                    case .success(let data):
//                        print(data)
//                        self.partySubject.send(
//                            data.map{ Party(DTO: $0) }
//                        )
//                    case .failure(let failure):
//                        print(failure)
//                    }
//                }
//            case .failure(let failure):
//                print(failure)
//            }
        }
    }
}
