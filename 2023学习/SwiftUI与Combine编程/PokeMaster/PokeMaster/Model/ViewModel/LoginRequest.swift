//
//  LoginRequest.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/12/2.
//

import Foundation
import Combine

struct LoginRequest {
    let email: String
    let password: String
    
    /// 发布登录结果
    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0, execute: {
                if self.password == "password" {
                    let user = User(email: self.email, favoritePokemonIDs: [])
                    promise(.success(user))
                } else {
                    promise(.failure(.passwordWrong))
                }
            })
        }
        .receive(on: DispatchQueue.main) // 放到主线程，因为要刷新UI
        .eraseToAnyPublisher()
    }
}
