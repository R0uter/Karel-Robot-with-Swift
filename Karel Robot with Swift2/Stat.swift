//
//  Stat.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 15/8/3.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation

enum Direction {               //创建一个代表karel朝向的枚举。
    case east,south,west,north
}//End of Direction


enum Error:ErrorType {      //创建一个错误类型，用来传出撞墙的错误……不知道该放哪，我就扔这里了。
    case duang,noBeeper,eof
} //错误类型结束