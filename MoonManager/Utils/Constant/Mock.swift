//
//  Mock.swift
//  MoonManager
//
//  Created by cschoi on 1/3/24.
//

import Foundation

class Mock {
    
    static let party1: PartyDTO = PartyDTO(
        id: UUID().uuidString,
        name: "일본 도쿄 4박5일 🇯🇵🗼",
        members: [member1, member2, member3, member4],
        spending: [
            SpendingDTO(
                id: UUID().uuidString,
                manager: member1,
                title: "마라 로제 떡볶이",
                cost: 30000,
                members: [member1, member2, member3]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                manager: member2,
                title: "호떡",
                cost: 4000,
                members: [member1, member2, member3, member4]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                manager: member1,
                title: "스타벅스",
                cost: 12000,
                members: [member1, member3]
            )
        ]
    )
    
    static let party2: PartyDTO = PartyDTO(
        id: "2",
        name: "제주도 3박4일 😊",
        members: [member1, member2, member3],
        spending: []
    )
    
    static let party3: PartyDTO = PartyDTO(
        id: "3",
        name: "태국 방콕 가보자구~~🇹🇭",
        members: [],
        spending: []
    )
    
    static let member1: MemberDTO = MemberDTO(
        id: "1", name: "라이언"
    )
    
    static let member2: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "무지"
    )
    
    static let member3: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "죠르디"
    )
    
    static let member4: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "춘식이"
    )
    
    static let member5: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "어피치"
    )
    
    static let member6: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "프로도"
    )
    
    static let member7: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "제이지"
    )
}
