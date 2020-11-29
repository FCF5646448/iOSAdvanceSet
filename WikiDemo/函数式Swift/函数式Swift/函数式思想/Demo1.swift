//
//  Demo1.swift
//  函数式Swift
//
//  Created by 冯才凡 on 2020/11/26.
//  Copyright © 2020 冯才凡. All rights reserved.
//

import Foundation

fileprivate typealias Distance = Double

//
fileprivate struct Position {
    var x: Double
    var y: Double
}

extension Position {
    // 判断当前点是否在range之内
    func within(range: Distance) -> Bool {
        return sqrt(x*x + y*y) <= range
    }
}

fileprivate struct Ship {
    var position: Position
    var firingRange: Distance   // 攻击范围
    var unsafeRange: Distance   //
}

extension Ship {
    /*
     判断目标船是否在当前船的攻击范围呢
     计算目标船与当前船只的距离，来判断.
     */
    func canEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx*dx + dy*dy)
        return targetDistance <= firingRange
    }
}

extension Ship {
    /*
     判断当前船是否在不安全区域内
     如果目标船与当前船只靠的太近，就不安全
     */
    func canSafeEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx*dx + dy*dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
}

extension Ship {
    /*
     
     */
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx*dx + dy*dy)
        
        let friendlydx = friendly.position.x - target.position.x
        let friendlydy = friendly.position.y - target.position.y
        let friendlytargetDistance = sqrt(friendlydx*friendlydx + friendlydy*friendlydy)
        
        return targetDistance <= firingRange && targetDistance > unsafeRange && (friendlytargetDistance > unsafeRange)
    }
}
