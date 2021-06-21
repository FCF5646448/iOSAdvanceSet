//
//  ButtleShip.swift
//  FunctionalLearn
//
//  Created by fengcaifan on 2021/6/19.
//

import Foundation

/// 定义一种Distance类型，表示距离的类型，实际上是Double类型
typealias Distance = Double

/// 定义Position结构体，表示一个位置
struct Position {
    var x: Double
    var y: Double
}

extension Position {
    /// 当前position距离原点的距离是否小于range。
    func within(range: Distance) -> Bool {
        return sqrt(x*x + y*y) <= range
    }
    
    /// 返回一个相对位置，（x\y轴的距离）
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    /// 表示距离原点的直线距离，也表示相对位置的值
    var length: Double {
        return sqrt(x * x + y * y)
    }
}

/// 定义一个Ship结构体，表示Ship相关信息
struct Ship {
    var position: Position // 当前Ship的位置
    var firingRange: Distance   // 可以开火的距离
    var unsafeRange: Distance   // 不安全的距离（炮弹落到这个范围内，就会收到伤害，自己的炮弹也不能落入这个位置）
}

extension Ship {
    /// 检查另一艘船是否在安全的可攻击范围内: 也就是目标船只与当前船只的距离<= firingRange && >= unsafeRange，攻击目标船只不会伤害到友船：目标船只与友船到距离在unsafeRange之外
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        let canEngage = targetDistance <= firingRange && targetDistance >= unsafeRange
        let friendlyDx = friendly.position.x - target.position.x
        let friendlyDy = friendly.position.y - target.position.y
        let friendToTargetDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        let friendSafe = friendToTargetDistance > unsafeRange
        return canEngage && friendSafe
    }
    
    /// 优化函数
    func canSafelyEngage2(ship target: Ship, friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(position).length
        let friendToTargetDistance = target.position.minus(friendly.position).length
        let canEngage = targetDistance <= firingRange && targetDistance >= unsafeRange
        let friendSafe = friendToTargetDistance > unsafeRange
        return canEngage && friendSafe
    }
}


extension Ship {
    /// 判断一个点是否在范围里
    func pointInRange(point: Position) -> Bool {
        fatalError("pointInRange")
    }

    /// 定义一个函数类型，表示将一个Posion转成一个bool值。注意不要用面向对象的思想去试图理解什么Positision转成什么Bool值。只需理解是一种值类型的转换就行
    /// 语义上这个函数类似可以表示：一个点是否在某个区域里
    typealias Region = (Position) -> Bool

    /// 如果函数类型作为返回值。那么这个函数就是一个类似于辅助实现函数类型的条件。

    /// 给出一个条件，用于实现从Position到Bool的转换
    /// 判断点是否在以原点为圆心，radius为半径的圆内
    func cicle(radius: Distance) -> Region {
        return {p in
            return p.length <= radius
        }
    }

    /// 判断点是否在以center为原点，radius为半径的圆内
    func cicle2(radius: Distance, center: Position) -> Region {
        return { p in
            let distance = p.minus(center).length
            return distance <= radius
        }
    }


    /// 如果函数类型作为参数，那么这个函数类型就是一个“处理方式”的作用，也就是说这个函数参数可以将处理结果传递回来，而处理过程是在回调的地方。
    /// 这个函数是给定一个处理方式和参数，去实现将Position到Bool的转换。而这个处理过程也是将Position转成Bool类型，所以可以直接返回函数参数的处理结果。
    /// 这里可以理解为以offset为圆心的区域。
    func shift(_ region: @escaping Region, by offset: Position) -> Region {
        return { p in
            return region(p.minus(offset))
        }
    }
    
    /// 点是否在regoin区域以外
    func invert(_ region: @escaping Region) -> Region {
        return { point in !region(point)}
    }
    
    /// 点是否在两个区域相交的区域。返回值可以理解为相交区域
    func intersect(_ region: @escaping Region, with other: @escaping Region) -> Region {
        return { p in region(p) && other(p)}
    }
    
    /// 两个区域的并集
    func union(_ region: @escaping Region, with other: @escaping Region) -> Region {
        return {p in region(p) || other(p) }
    }
    
    ///region和origin的并集减去region和origin的交集
    func subtract(_ region: @escaping Region, from origin: @escaping Region) -> Region {
        return intersect(origin, with: invert(region))
    }
    
    func test() {
        /// (5,5)是否在以原点为圆心，半径为radius的圆内
        let shifted = shift(cicle(radius: 10), by: Position(x: 5, y: 5))
        
        /// 上面的函数就等同于这样调用
        let shifted2 = shift({ p in
            return p.length <= 10
        }, by: Position(x: 10, y: 10))
        
        debugPrint(shifted)
        debugPrint(shifted2)
        
    }

    /// 优化函数3
    func canSafelyEngage3(ship target: Ship, friendly: Ship) -> Bool {
        /// firing与unsafe之间的区域
        let rangeRegion = subtract(cicle(radius: unsafeRange), from: cicle(radius: firingRange))
        /// 以posion为圆心的“firing和unsafe的区域”
        let firingRegion = shift(rangeRegion, by: position)
        /// 以友船坐标为圆心的非安全区域
        let friendlyRegion = shift(cicle(radius: unsafeRange), by: friendly.position)
        /// 在firing区域，不在友船的非安全区域 (最终可用的区域)
        let resultRegion = subtract(friendlyRegion, from: firingRegion)
        //
        return resultRegion(target.position)
    }
}
