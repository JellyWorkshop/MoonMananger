//
//  Mock.swift
//  MoonManager
//
//  Created by cschoi on 1/3/24.
//

import Foundation
import RealmSwift

class Mock {
    
    static let party1: PartyDTO = PartyDTO(
        id: "1",
        name: "일본 도쿄 4박5일 🇯🇵🗼",
        members: [member1, member2, member3, member4, member5],
        spendings: [
            SpendingDTO(
                id: UUID().uuidString,
                title: "마라 로제 떡볶이",
                cost: 50000,
                manager: member1,
                members: [member1, member2, member5]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "호떡",
                cost: 3000,
                manager: member2,
                members: [member1, member2, member3, member4]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "김밥",
                cost: 17000,
                manager: member5,
                members: [member1, member2, member3, member4, member5, member7]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "스타벅스",
                cost: 12000,
                manager: member1,
                members: [member1, member3]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "코인노래방",
                cost: 10000,
                manager: member1,
                members: [member1, member2, member3, member5]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "다트",
                cost: 23000,
                manager: member2,
                members: [member1, member3, member4, member5]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "CGV",
                cost: 47000,
                manager: member5,
                members: [member1, member3, member5]
            )
        ],
        image: "test_image3"
    )
    
    static let party2: PartyDTO = PartyDTO(
        id: "2",
        name: "제주도 3박4일 😊",
        members: [member1, member2, member3, member4],
        spendings: [
            SpendingDTO(
                id: UUID().uuidString,
                title: "마라 로제 떡볶이",
                cost: 30000,
                manager: member1,
                members: [member1, member2, member3]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "김밥",
                cost: 20000,
                manager: member1,
                members: [member1, member2, member3, member4]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "스타벅스",
                cost: 20000,
                manager: member2,
                members: [member1, member2, member3, member4]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "코인노래방",
                cost: 10000,
                manager: member2,
                members: [member2, member3]
            )
        ],
        image: "test_image2"
    )
    
    static let party3: PartyDTO = PartyDTO(
        id: "3",
        name: "태국 방콕 가보자구~~🇹🇭",
        members: [member1, member2, member3, member4, member5, member6, member7],
        spendings: [
            SpendingDTO(
                id: UUID().uuidString,
                title: "마라 로제 떡볶이",
                cost: 30000,
                manager: member1,
                members: [member1, member2, member3]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "호떡",
                cost: 4000,
                manager: member2,
                members: [member1, member2, member3, member4]
            ),
            SpendingDTO(
                id: UUID().uuidString,
                title: "스타벅스",
                cost: 12000,
                manager: member1,
                members: [member1, member3]
            )
        ],
        image: "test_image"
    )
    
    static let member1: MemberDTO = MemberDTO(
        id: "1", name: "라이언"
    )
    
    static let member2: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "무지"
    )
    
    static let member3: MemberDTO = MemberDTO(
        id: "3", name: "죠르디"
    )
    
    static let member4: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "춘식이"
    )
    
    static let member5: MemberDTO = MemberDTO(
        id: "5", name: "어피치"
    )
    
    static let member6: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "프로도"
    )
    
    static let member7: MemberDTO = MemberDTO(
        id: UUID().uuidString, name: "제이지"
    )
}
