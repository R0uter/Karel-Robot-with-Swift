//
//  Stat.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 15/8/3.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Cocoa

var karel = Run() // 生成 Karel 的实例

var beeper = [NSImageView](repeating: NSImageView(), count: 100) // 虽然很2，但我用这个 Beeper 数组储存 Beeper ……
var beeperCount = [NSTextField](repeating: NSTextField(), count: 100) // 这个是用来显示 Beeper 堆叠数量的 Feild ……
var block = [NSImageView](repeating: NSImageView(), count: 100) // 同样的，用它来储存 Block ……
// 为了所有的类都能访问到，我用了一堆的全局变量，不要骂我，么么哒。
var mainQueue = OperationQueue.main
var backgroundQueue = OperationQueue()
var workingThread: Thread?
var observerQueue = OperationQueue()
var isPaused = false
let error = ErrorObserver()
var canceled = false

var slowTime: Double = 0.2
/**
 代表karel朝向的枚举

 - east:  东
 - south: 南
 - west:  西
 - north: 北
 */
enum Direction {
    case east, south, west, north
} // End of Direction

/**
 创建一个错误类型，用来传出撞墙的错误……不知道该放哪，我就扔这里了。

 - duang:    撞墙的错误信号
 - noBeeper: 脚下没有Beeper
 */
enum KarelError: Error {
    case duang, noBeeper
} // 错误类型结束
