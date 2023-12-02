//
//  AppError.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/12/2.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription } // 后续建议使用error code作为id

    case alreadyRegistered
    case passwordWrong

    case requiresLogin
    case networkingFailed(Error)
    case fileError
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .alreadyRegistered: return "该账号已注册"
        case .passwordWrong: return "密码错误"
        case .requiresLogin: return "需要账户"
        case .networkingFailed(let error): return error.localizedDescription
        case .fileError: return "文件操作错误"
        }
    }
}
