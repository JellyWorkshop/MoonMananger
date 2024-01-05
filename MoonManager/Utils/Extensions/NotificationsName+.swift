//
//  NotificationsName.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation

extension Notification.Name {
    /// 오리엔테이션(가로/세로) 상태 알림
    static let orientationChanged = Notification.Name(rawValue: "orientationChanged")
    /// 방송방 방송 재생 상태알림 object : Bool
    static let isPlaying = Notification.Name(rawValue: "isPlaying")
    /// 방송방 방송 재생, 일시정지 선택 알림
    static let videoPlayAndPause = Notification.Name(rawValue: "videoPlayAndPause")
    /// 크리에이터 즐겨찾기 상태 변경알림 userInfo [isBookmarked: bool , channel: String]
    static let updateFavorite = Notification.Name(rawValue: "updateFavorite")
    /// 크리에이터 차단 상태 변경알림 userInfo [isBlock: bool , channel: String]
    static let updateBlock = Notification.Name(rawValue: "updateBlock")
    /// 메인에서 이미 선택된 메뉴 enum 값 알림,  object: Int , ( 홈, 탐색, 즐겨찾기, 마이페이지)
    static let alreadySelectedScene = Notification.Name(rawValue: "alreadySelectedScene")
    /*/// 데이터 갱신 알림
    static let reloadData = Notification.Name(rawValue: "reloadData")*/
    /// 로그인된 사용자정보가 변경됨
    static let userInfoChanged = Notification.Name(rawValue: "user.changedInfo")
    /// 사용자가 로그인됨
    static let userLogggedIn = Notification.Name(rawValue: "user.logggedIn")
    /// 사용자가 로그아웃됨
    static let userLogggedOut = Notification.Name(rawValue: "user.logggedOut")
}
