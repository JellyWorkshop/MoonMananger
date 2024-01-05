//
//  Mock.swift
//  MoonManager
//
//  Created by cschoi on 1/3/24.
//

import Foundation

class Mock {
    
    static let party1: PartyDTO = PartyDTO(
        id: "1",
        name: "일본 도쿄 4박5일 🇯🇵🗼",
        members: []
    )
    
    static let party2: PartyDTO = PartyDTO(
        id: "2",
        name: "제주도 3박4일 😊",
        members: []
    )
    
    static let party3: PartyDTO = PartyDTO(
        id: "3",
        name: "태국 방콕 가보자구~~🇹🇭",
        members: []
    )
    
    static let member1: MemberDTO = MemberDTO(
        id: "1", name: "라이언"
    )
    
    static let member2: MemberDTO = MemberDTO(
        id: "2", name: "무지"
    )
    
    static let member3: MemberDTO = MemberDTO(
        id: "3", name: "죠르디"
    )
    
    static let member4: MemberDTO = MemberDTO(
        id: "4", name: "춘식이"
    )
    
    static let member5: MemberDTO = MemberDTO(
        id: "5", name: "어피치"
    )
    
    static let member6: MemberDTO = MemberDTO(
        id: "6", name: "프로도"
    )
    
    static let member7: MemberDTO = MemberDTO(
        id: "7", name: "제이지"
    )
}
