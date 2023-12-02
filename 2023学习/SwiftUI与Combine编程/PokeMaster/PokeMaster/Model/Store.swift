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
        appState = result.0
        if let command = result.1 {
            print("[COMMAND]: \(command)")
            command.excute(in: self)
        }
    }
    
    static func reduce(state: AppState,
                       action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        switch action {
        case .login(let email, let password):
            guard !appState.settings.loginRequesting else {
                break
            }
            appState.settings.loginRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)
        case .accountBehaviorDone(let result):
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                appState.settings.loginError = error
            }
        case .logout:
            appState.settings.loginUser = nil
        }
        return (appState, appCommand)
    }
}
