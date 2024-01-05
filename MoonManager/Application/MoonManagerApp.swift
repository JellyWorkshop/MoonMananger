//
//  MoonManagerApp.swift
//  MoonManager
//
//  Created by cschoi on 12/28/23.
//

import SwiftUI
import Swinject

@main
struct MoonManagerApp: App {
    private let injector: Injector
    @ObservedObject private var coordinator: Coordinator
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        coordinator = Coordinator(.main)
        injector = DependencyInjector(
            container: Container(defaultObjectScope: .container)
        )
        
        injector.assemble(
            [  
                RootAssembly(),
                DomainAssembly(),
                DataAssembly(),
                PresentationAssembly(coordinator: coordinator)
            ]
        )
        coordinator.injector = injector
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.buildInitialScene()
                    .navigationDestination(
                        for: Destination.self,
                        destination: { scene in
                            coordinator.buildScene(scene: scene)
                        }
                    )
            }
        }.onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("active")
                break
            case .inactive:
                print("inactive")
                break
            case .background:
                print("background")
                break
            @unknown default:
                break
            }
        }
    }
}
