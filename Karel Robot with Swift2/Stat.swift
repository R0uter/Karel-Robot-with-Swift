//
//  Stat.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 15/8/3.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation

struct Stat {       //声明一个储存 Karel 状态的结构体，用来保存每一步 Karel 的状态。
    var  coordinate:NSPoint?        //当前 Karel 的坐标
    var beeper:Int?     //是对Beeper的动作
    var direction:Direction?        //当前的方向
    var blocked:Bool = false        //储存是否撞墙的状态
    
    init () {       //写一个初始化器，用来串联整个动作当中 Karel 的朝向，解决方向跑偏的问题。
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
    
    init (direction:Direction) {        //用方向初始化 Karel 状态
        self.direction = direction
    }
    
    init (coordinate:NSPoint,blocked:Bool) {        //用坐标信息初始化 Karel 状态
        self.init()
        self.coordinate = coordinate
        self.blocked = blocked
        
           }
    
    func getRealCoordinate(co:NSPoint)-> NSPoint {      //这里还得来一个获取真实坐标的方法，其实可以和那个合并……吧……
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

}//Stat 结束

enum Direction {               //创建一个代表karel朝向的枚举。
    case east,south,west,north
}//End of Direction


enum Error:ErrorType {      //创建一个错误类型，用来传出撞墙的错误……不知道该放哪，我就扔这里了。
    case duang
} //错误类型结束