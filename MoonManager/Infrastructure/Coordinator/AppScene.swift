//
//  AppScene.swift
//  MoonManager
//
//  Created by cschoi on 1/4/24.
//

import Foundation

// Presentation 영역 - AppScene
public enum AppScene: Hashable {
    case main
    case party(id: String)
    case partyMember(id: String)
}
