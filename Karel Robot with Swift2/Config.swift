//
//  Config.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 16/2/1.
//  Copyright © 2016年 R0uter. All rights reserved.
//

import Foundation
/**
 *  在这里设置 Karel 的初始位置信息，比如朝向，比如坐标，比如Beeper和Block。
 */
struct Config {
    typealias x = Int
    typealias y = Int
    typealias number = Int
    
    private var direction:Direction = .east
    private var coordinate:NSPoint = NSPoint(x: 0, y: 0)
    private var initBlock:[(x,y)] = []
    private var initBeeper:[(x,y,number)] = []
    /**
     在这里覆盖配置，配置信息写在初始化器里，直接覆盖初始化器即可！
     
     direction 为Karel的朝向 分为 .east .north .south .west
     coordinate 为Karel的初始位置
     initBlock 为初始化墙壁信息，格式为[(x,y)]：[(3,3),(4,4)]
     initBeeper 为初始化Beeper信息，格式为[(x,y,number)]：[(1,1,1),(2,2,8)]
     
     */
    init () {
        direction = .east
        coordinate = NSPoint(x: 0, y: 0)
        initBlock = [(3,3),(4,4)]
        initBeeper = [(1,1,1),(2,2,8)]
    }
}//这里创建Beeper！  三个整形元组，第三个数字是Beeper的堆叠数量！前两个是坐标。


// MARK: - 写一堆getter
extension Config {
    var getDirection:Direction {
        return direction
    }
    var getCoordinate:NSPoint {
        return coordinate
    }
    var getInitBlock:[(Int,Int)] {
        return initBlock
    }
    var getInitBeeper:[(Int,Int,Int)] {
        return initBeeper
    }
}