//
//  AppEnvironment.swift
//  MoonManager
//
//  Created by cschoi on 1/3/24.
//

import Foundation

enum PHASE {
    case DEV, ALPHA, REAL
}

struct AppEnvironment {
    let phase: PHASE = .DEV
    let appState: AppState = AppState()
}
