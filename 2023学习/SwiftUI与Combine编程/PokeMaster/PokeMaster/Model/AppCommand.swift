//
//  AppCommand.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/12/2.
//

import Foundation
import Combine

protocol AppCommand {
    func excute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    
    /// 使用sink订阅LoginRequest.publisher
    func excute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(email: email, password: password)
            .publisher
            .sink { complete in
                // 发生错误的回调
                if case .failure(let error) = complete {
                    store.dispatch(.accountBehaviorDone(result: .failure(error)))
                }
                token.unseal() // 释放AnyCancellable
            } receiveValue: { user in
                // 登录成功的回调
                store.dispatch(.accountBehaviorDone(result: .success(user)))
            }
            .seal(in: token)
    }
}


class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
