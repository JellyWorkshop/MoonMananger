//
//  AppState.swift
//  MoonManager
//
//  Created by cschoi on 1/4/24.
//

import Combine
import Foundation
import SwiftUI

struct AppState: Equatable {
    var userData = UserData()
    var system = System()
    var permissions = Permissions()
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.userData == rhs.userData &&
            lhs.system == rhs.system &&
            lhs.permissions == rhs.permissions
    }
}

extension AppState {
    struct UserData: Equatable {
        /*
         The list of countries (Loadable<[Country]>) used to be stored here.
         It was removed for performing countries' search by name inside a database,
         which made the resulting variable used locally by just one screen (CountriesList)
         Otherwise, the list of countries could have remained here, available for the entire app.
         */
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

extension AppState {
    enum Permission {
        case pushNotifications
        enum Status: Equatable {
            case unknown
            case notRequested
            case granted
            case denied
        }
    }
    
    struct Permissions: Equatable {
        var push: Permission.Status = .unknown
    }
    
    static func permissionKeyPath(for permission: Permission) -> WritableKeyPath<AppState, Permission.Status> {
        let pathToPermissions = \AppState.permissions
        switch permission {
        case .pushNotifications:
            return pathToPermissions.appending(path: \.push)
        }
    }
}


