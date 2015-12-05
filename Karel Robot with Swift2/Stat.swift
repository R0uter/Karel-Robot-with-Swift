//
//  Stat.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 15/8/3.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Cocoa
var karel = Run()   //生成 Karel 的实例

var beeper = [NSImageView](count: 100, repeatedValue: NSImageView()) //虽然很2，但我用这个 Beeper 数组储存 Beeper ……
var beeperCount = [NSTextField](count: 100, repeatedValue: NSTextField()) //这个是用来显示 Beeper 堆叠数量的 Feild ……
var block = [NSImageView](count: 100, repeatedValue: NSImageView() ) //同样的，用它来储存 Block ……
//为了所有的类都能访问到，我用了一堆的全局变量，不要骂我，么么哒。
var mainQueue = NSOperationQueue.mainQueue()
var backgroundQueue = NSOperationQueue()
var workingThread:NSThread?
var observerQueue = NSOperationQueue()
var isPaused = false
let error = ErrorObserver()
var canceled = false

var slowTime:Double = 0.2

enum Direction {               //创建一个代表karel朝向的枚举。
    case east,south,west,north
}//End of Direction


enum Error:ErrorType {      //创建一个错误类型，用来传出撞墙的错误……不知道该放哪，我就扔这里了。
    case duang,noBeeper
} //错误类型结束