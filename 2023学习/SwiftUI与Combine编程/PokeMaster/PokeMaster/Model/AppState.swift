//
//  AppState.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/12/2.
//

import SwiftUI

struct AppState {
    var settings = Settings()
}

extension AppState {
    struct Settings {
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }
        
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
        }
        
        var checker = AccountChecker()
        var showEnglishName = true
        var showFavoriteOnly = false
        var sorting = Sorting.id
        
        var loginUser: User?
    }
}
