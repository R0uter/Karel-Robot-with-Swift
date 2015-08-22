//
//  Run.swift
//  Karl Robot
//
//  Created by R0uter on 15/7/29.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation
import Cocoa

class Run:Karel {
    
    
//    func turnRight() {  //在这里可以声明更多自定义函数！
//    turnLeft()
//        turnLeft()
//        turnLeft()
//    }
    
    
    
    func run() {
//        backgrooundQueue.addOperationWithBlock(){
       
//            在这里写入操作Karl的方法～
//            只可以使用上边的四种方法！
            
            self.move()
        self.move()
            self.turnLeft()
            self.move()
            self.move()
         self.turnLeft()
        self.move()
        self.move()
        self.putBeeper()
        self.putBeeper()
        self.move()
//            self.turnRight()
            
            
                   }
        
    
}