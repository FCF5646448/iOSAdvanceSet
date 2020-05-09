import UIKit


//这个例子是《swift函数式编程的第一个例子》。计算某个点是否在当前ship的攻击范围之内。并且距离友方船只和我们自身都不太近。
typealias Distance = Double


struct Position {
    var x:Double
    var y:Double
}

//Mark : 面向对象过程
extension Position {
    //某人船的坐标是（0，0）。判断Position距离原点的位置。
    func withIn(range:Distance) -> Bool {
        return sqrt((x*x + y*y)) < range
    }
    
    //计算两个点（p、self）之间的距离,但是不取直线距离，实际上是把横纵坐标的差值，装饰成一个点的坐标。length就是实际直线距离
    func minus(_ p:Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    var length : Double {
        return sqrt(x*x + y*y)
    }
}


// 一艘船
struct Ship {
    var position : Position
    var firingRange : Distance //攻击范围
    var unsafeRange : Distance //不安全范围，指没法攻击，但是很危险的范围
}

extension Ship {
    //是否可安全攻击
//    func canSafelyEngage(ship target:Ship) -> Bool {
//        let dx = target.position.x - position.x
//        let dy = target.position.y - position.y
//        let targetDistance = sqrt(dx*dx + dy*dy)
//        return targetDistance <= firingRange && targetDistance >= unsafeRange
//    }
    
    //目标船在安全攻击范围内，且在友船的不安全范围之外。
//    func canSafelyEngage(ship target:Ship,friend:Ship) -> Bool {
//        let dx = target.position.x - position.x
//        let dy = target.position.y - position.y
//        let targetDistance = sqrt(dx*dx + dy*dy)
//
//        let friendDx = friend.position.x - target.position.x
//        let friendDy = friend.position.y - target.position.y
//        let friendDistance = sqrt(friendDx * friendDx + friendDy * friendDy)
//
//        return targetDistance <= firingRange && targetDistance >= unsafeRange && friendDistance > unsafeRange
//    }
    
//    func canSafelyEngage(ship target:Ship,friend:Ship) -> Bool {
//        let targetDistance = position.minus(target.position).length
//        let friendDistance = position.minus(friend.position).length
//        return targetDistance <= firingRange && targetDistance >= unsafeRange && friendDistance > unsafeRange
//    }
    
    func canSafelyEngage(ship target:Ship, friendly:Ship) -> Bool {
        let rangeRegion = subtract(circle(radius: unsafeRange), from: circle(radius: firingRange))
        
        let firingRegion = shift(rangeRegion, by: position)
        
        let friendRegion = shift(circle(radius: unsafeRange), by: friendly.position)
        
        let resultRegion = subtract(friendRegion, from: firingRegion)
        
        return resultRegion(target.position)
        
    }
    
    
    //一个区域内是否包含某点
    //func positionInRange(posint:Position) -> Bool {
    //
    //    return true
    //}

    //Mark : 函数式编程过程
    //Region 代表一个点是否在区域内的函数
    typealias Region = (Position)->Bool

    //判断point是否在 圆心(0，0),半径radius的圆内
    func circle(radius:Distance) -> Region {
        return {point in point.length <= radius}
    }

    //判断point是否在半径为radius、原点为center的圆内
    func circle2(radius:Distance, center:Position) -> Region {
        return {point in point.minus(center).length <= radius}
    }

    //
    func shift(_ region:@escaping Region, by offset:Position) -> Region {
        return {point in region(point.minus(offset))}
    }

    func invert(_ region:@escaping Region) -> Region {
        return {point in !region(point)}
    }

    func intersect(_ region:@escaping Region, with other:@escaping Region) -> Region {
        return {point in region(point) && other(point)}
    }

    func subtract(_ region:@escaping Region, from original:@escaping Region) -> Region {
        return intersect(original, with: invert(region))
    }
    
}





/*
 总结：
 1、结构体会有一个默认初始化函数，所以即使不给成员变量初始值仍不会报错！
 2、
 
 */



/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.next = nil
 *     }
 * }
 */

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
         self.val = val
         self.next = nil
    }
}

class Solution {
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        if l1 == nil {
            return l2
        }else if l2 == nil {
            return l1
        }
        if l1!.val <= l2!.val {
            l1!.next = mergeTwoLists(l1!.next,l2)
            return l1
        }else{
            l2!.next = mergeTwoLists(l1,l2!.next)
            return l2
        }
    }
}



