//
//  Stat.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 15/8/3.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation

struct Stat {
//     声明一个储存 Karel 状态的结构体，用来保存每一步 Karel 的状态。
    var  coordinate:NSPoint?
    var beeper:Int?
    var direction:Direction?
    var blocked:Bool = false
    
    init () {
        direction = .east
        var count = karelStat.count - 1
        while count > 0 {
            if let c = karelStat[count].direction {
                self.direction = c
                break
            }
            --count
            
        }

    }
    
    init (direction:Direction) {
        self.direction = direction
    }
    
    init (coordinate:NSPoint,blocked:Bool) {
        self.init()
        self.coordinate = coordinate
        self.blocked = blocked
        
           }
    
    func getRealCoordinate(co:NSPoint)-> NSPoint {
        let coordinate = co
        var currentPoint = NSPoint()
        
        switch direction! {
            case .east:
                currentPoint.x = coordinate.x * 60 + 5
                currentPoint.y = coordinate.y * 50
            case .south:
                currentPoint.x = coordinate.x * 60 + 5
                currentPoint.y = coordinate.y * 50 + 50
            case .west:
                currentPoint.x = coordinate.x * 60 + 65
                currentPoint.y = coordinate.y * 50 + 50
            case .north:
                currentPoint.x = coordinate.x * 60 + 55
                currentPoint.y = coordinate.y * 50
        }
        return currentPoint
    }

 
    
}

enum Direction {                                    //创建一个代表karel朝向的枚举。
    case east,south,west,north
}//End of Direction
enum Error:ErrorType {
    case duang
}