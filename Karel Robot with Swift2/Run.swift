//
//  Run.swift
//  Karl Robot
//
//  Created by R0uter on 15/7/29.
//  Copyright © 2015年 R0uter. All rights reserved.
//

class Run:Karel {
    func run() {

/*  ————————————————————————————————————————————————————————————————————————
        在 run() 函数当中写对 Karel 的操作吧，你可以使用如下四中方法来操作 karel 机器人：
            move()
            turnLeft()
            pickBeeper()
            putBeeper()
       不过你也可以自定义其他更多的功能，比如说下边的 turnRight() 函数。
        
        Hope enjoy！

—————————————————————————————————————————————————————————————————————————— */
      
        move()
        move()
        pickBeeper()
        pickBeeper()
        move()
        turnLeft()
        move()
        move()
        putBeeper()
        putBeeper()
        move()
        move()
        move()
        putBeeper()
        putBeeper()
        move()
        turnRight()
        move()
        move()
        move()
        putBeeper()
        putBeeper()
        move()
        
            
}
        func turnRight() {  //在这里可以声明更多自定义函数！
            turnLeft()
            turnLeft()
            turnLeft()
        }
        
    
}