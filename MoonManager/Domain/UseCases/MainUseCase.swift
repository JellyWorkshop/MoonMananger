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
        partyRepository.retrievePartyList { result in
            switch result {
            case .success(let data):
                partySubject.send(
                    data.map{ Party(DTO: $0) }
                )
            case .failure(let error):
                print(error)
            }
        }
    }
}
