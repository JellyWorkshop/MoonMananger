//
//  Convertable.swift
//  MoonManager
//
//  Created by cschoi on 1/3/24.
//

import Foundation

protocol Convertable {
    associatedtype E: Codable

    init(DTO: E)
}
