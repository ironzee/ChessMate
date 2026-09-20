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
    case ghostMode
    case login
    case signup
    case settings
    case profilePhotos
    case matchRequests
    case game(String)
    case botGame
    case editPhotosTemp(SignUpTempData)
    case cafeFinderWithCafe(Cafe)

    // ✅ New onboarding steps
    case onboardingOpeningMove
    case onboardingCafeStyle
    case onboardingMatchSettings
    case onboardingPersona
    case onboardingCoffeeOrder
    case onboardingPlayStyle
    
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
        case .ghostMode: hasher.combine("ghostMode")
        case .login: hasher.combine("login")
        case .signup: hasher.combine("signup")
        case .settings: hasher.combine("settings")
        case .profilePhotos: hasher.combine("profilePhotos")
        case .matchRequests: hasher.combine("matchRequests")
        case .game(let id):
            hasher.combine("game")
            hasher.combine(id)
        case .botGame:
            hasher.combine("botGame")
        case .editPhotosTemp(let data):
            hasher.combine("editPhotosTemp")
            hasher.combine(data.name)
            hasher.combine(data.email)
            hasher.combine(data.password)
            hasher.combine(data.location)
        case .cafeFinderWithCafe(let cafe):
            hasher.combine("cafeFinderWithCafe")
            hasher.combine(cafe.id)

        // ✅ Add onboarding cases to hashing
        case .onboardingOpeningMove: hasher.combine("onboardingOpeningMove")
        case .onboardingCafeStyle: hasher.combine("onboardingCafeStyle")
        case .onboardingMatchSettings: hasher.combine("onboardingMatchSettings")
        case .onboardingPersona: hasher.combine("onboardingPersona")
        case .onboardingCoffeeOrder: hasher.combine("onboardingCoffeeOrder")
        case .onboardingPlayStyle: hasher.combine("onboardingPlayStyle")
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
             (.ghostMode, .ghostMode),
             (.login, .login),
             (.signup, .signup),
             (.settings, .settings),
             (.profilePhotos, .profilePhotos),
             (.matchRequests, .matchRequests),
             (.botGame, .botGame),
             (.onboardingOpeningMove, .onboardingOpeningMove),
             (.onboardingCafeStyle, .onboardingCafeStyle),
             (.onboardingMatchSettings, .onboardingMatchSettings),
             (.onboardingPersona, .onboardingPersona),
             (.onboardingCoffeeOrder, .onboardingCoffeeOrder),
             (.onboardingPlayStyle, .onboardingPlayStyle):
            return true

        case (.chat(let a), .chat(let b)),
             (.chatDetail(let a), .chatDetail(let b)):
            return a.id == b.id

        case (.editPhotosTemp(let a), .editPhotosTemp(let b)):
            return a.name == b.name &&
                   a.email == b.email &&
                   a.password == b.password &&
                   a.location == b.location

        case (.cafeFinderWithCafe(let a), .cafeFinderWithCafe(let b)):
            return a.id == b.id

        case (.game(let a), .game(let b)):
            return a == b

        default:
            return false
        }
    }
}

