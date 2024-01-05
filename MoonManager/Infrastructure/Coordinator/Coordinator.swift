//
//  Coordinator.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import SwiftUI
import Combine

// App 영역 - Coordinator
public class Coordinator: ObservableObject, CoordinatorProtocol {
    @Published public var path: NavigationPath // 앱 전반에 걸쳐 공유되야 하는 변수
    private let initialScene: Destination
    var injector: Injector?
    
    public init(_ initialScene: Destination) {
        self.initialScene = initialScene
        self.path = NavigationPath()
    }
    
    // 앱을 켤 때 처음 나타나는 뷰를 정함
    public func buildInitialScene() -> some View {
        return buildScene(scene: initialScene)
    }
    
    // 원하는 화면으로 이동하기
    public func push(_ scene: Destination) {
        path.append(scene)
    }
    
    // 뒤로가기
    public func pop() {
        path.removeLast()
    }
    
    // Root 화면으로 뒤로가기
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    // 이동할 화면을 생성함
    @ViewBuilder
    public func buildScene(scene: Destination) -> some View {
        switch scene {
        case .main:
            injector?.resolve(MainView.self)
        case .party(let id):
            injector?.resolve(PartyView.self, argument: id)
        case .partyMember(let id):
            injector?.resolve(PartyMemberView.self, argument: id)
        }
    }
}
