//
//  CoordinatorProtocol.swift
//  MoonManager
//
//  Created by cschoi on 1/4/24.
//

import Foundation

// Presentation 영역 - CoordinatorProtocol
public protocol CoordinatorProtocol {
    func push(_ scene: Destination)
    func pop()
    func popToRoot()
}
