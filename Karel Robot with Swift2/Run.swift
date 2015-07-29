//
//  Run.swift
//  Karl Robot
//
//  Created by R0uter on 15/7/29.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation
import Cocoa

class Run {
   
    func move() {
        sleep(UInt32(slowTime)) //不要怪我，我确实不会延迟的写法………………
            karel.move()
    }
    
    func turnLeft() {
        sleep(UInt32(slowTime))
            karel.turnLeft()
    }
    
    func pickBeeper() {
        sleep(UInt32(slowTime))
        karel.pickBeeper()
        
    }
    
    func putBeeper() {
        sleep(UInt32(slowTime))
        karel.putBeeper()
        
    }
    
    func run() {
        backgrooundQueue.addOperationWithBlock(){
       
//            在这里写入操作Karl的方法～
//            只可以使用上边的四种方法！
            
            
            
            
                   }}
        
    
}