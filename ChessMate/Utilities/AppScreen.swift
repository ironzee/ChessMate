//
//  AppScreen.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

//
//  AppScreen.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import Foundation

enum AppScreen: Hashable {
    case onboarding
    case home
    case matchmaking
    case chatList
    case chat(ChatModel)
    case chatDetail(ChatModel)
    case submitResult
    case profile
    case leaderboard
    case cafeFinder
    case matchHistory
    case notificationCenter
    case tournamentDiscovery
    case cafeDetails
    case ghostMode
    case login
    case signup
    case settings
    case profilePhotos
    case matchRequests
    case editPhotosTemp(SignUpTempData) // ✅ ADDED

    func hash(into hasher: inout Hasher) {
        switch self {
        case .onboarding: hasher.combine("onboarding")
        case .home: hasher.combine("home")
        case .matchmaking: hasher.combine("matchmaking")
        case .chatList: hasher.combine("chatList")
        case .chat(let model):
            hasher.combine("chat")
            hasher.combine(model.id)
        case .chatDetail(let model):
            hasher.combine("chatDetail")
            hasher.combine(model.id)
        case .submitResult: hasher.combine("submitResult")
        case .profile: hasher.combine("profile")
        case .leaderboard: hasher.combine("leaderboard")
        case .cafeFinder: hasher.combine("cafeFinder")
        case .matchHistory: hasher.combine("matchHistory")
        case .notificationCenter: hasher.combine("notificationCenter")
        case .tournamentDiscovery: hasher.combine("tournamentDiscovery")
        case .cafeDetails: hasher.combine("cafeDetails")
        case .ghostMode: hasher.combine("ghostMode")
        case .login: hasher.combine("login")
        case .signup: hasher.combine("signup")
        case .settings: hasher.combine("settings")
        case .profilePhotos: hasher.combine("profilePhotos")
        case .matchRequests: hasher.combine("matchRequests")
        case .editPhotosTemp(let data):
            hasher.combine("editPhotosTemp")
            hasher.combine(data.name)
            hasher.combine(data.email)
            hasher.combine(data.password)
            hasher.combine(data.location)
        }
    }

    static func == (lhs: AppScreen, rhs: AppScreen) -> Bool {
        switch (lhs, rhs) {
        case (.onboarding, .onboarding),
             (.home, .home),
             (.matchmaking, .matchmaking),
             (.chatList, .chatList),
             (.submitResult, .submitResult),
             (.profile, .profile),
             (.leaderboard, .leaderboard),
             (.cafeFinder, .cafeFinder),
             (.matchHistory, .matchHistory),
             (.notificationCenter, .notificationCenter),
             (.tournamentDiscovery, .tournamentDiscovery),
             (.cafeDetails, .cafeDetails),
             (.ghostMode, .ghostMode),
             (.login, .login),
             (.signup, .signup),
             (.settings, .settings),
             (.profilePhotos, .profilePhotos),
             (.matchRequests, .matchRequests):
            return true
        case (.chat(let a), .chat(let b)),
             (.chatDetail(let a), .chatDetail(let b)):
            return a.id == b.id
        case (.editPhotosTemp(let a), .editPhotosTemp(let b)):
            return a.name == b.name &&
                   a.email == b.email &&
                   a.password == b.password &&
                   a.location == b.location
        default:
            return false
        }
    }
}
