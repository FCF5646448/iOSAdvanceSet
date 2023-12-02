//
//  Store.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/12/2.
//

import SwiftUI
import Combine

// 声明为ObservableObject的类，可以通过 @ObservedObject 或 @EnvironmentObject 来订阅
class Store: ObservableObject {
    @Published var appState = AppState()
}

extension Store {
    func dispatch(_ action: AppAction) {
        print("[ACTION]: \(action)")
        let result = Store.reduce(state: appState, action: action)
        appState = result
    }
    
    static func reduce(state: AppState, action: AppAction) -> AppState {
        var appState = state
        switch action {
        case .login(let email, let password):
            if password == "password" {
                let user = User(email: email, favoritePokemonIDs: [])
                appState.settings.loginUser = user
            }
        }
        return appState
    }
}
