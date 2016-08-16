//
//  Coordinate.swift
//  Karl Robot
//
//  Created by R0uter on 15/7/29.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation
/**
 *  创建一个用来换算 Karel 苦逼坐标偏移量的结构体（真的需要吗？）
 *  反正我就是懒得合并了，这样看起来更整洁不是吗？（其实是更乱了吧！）
 */
struct Coordinate {
 
    
     func getRealCoordinate(_ co:NSPoint)-> NSPoint {
        let coordinate = co
        var currentPoint = NSPoint()
        switch karel.getDirection {
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
