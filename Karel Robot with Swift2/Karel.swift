//
//  karel.swift
//  karel Robot
//
//  Created by R0uter on 15/7/29.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation
import Cocoa

class Karel:NSImageView {
    
    private var beeperNumCount = [Int](count: 100, repeatedValue: 0)
    private var coordinate:NSPoint = NSPoint(x: 0, y: 0) //karel 的当前坐标位置
    private var direction:Direction = .east //朝向
    private var getCoor = Coordinate()
    var getDirection:Direction {                        //这是个getter，我尝试用计算属性来搞定这件事情。但是问题在于我忘了哪里用过它了。——反正就留着吧：）
        get {
            return direction
        }
    } //End of getDirection

    enum Direction {                                    //创建一个代表karel朝向的枚举。
        case east,south,west,north
    }//End of Direction
    
    
    func initKarel () {                                 //初始化一个karel，我懒得写构造了，直接写个函数完事。
        self.frame = CGRectMake(4, 0, 50, 50)
        self.image = NSImage(named: "karel")
    }//End of initkarel()
    
    func initBlockAndBeeper() {                         //×××如果要创建地图则在这里修改坐标即可！××××××××
        let initBlock = [(9,0), (8,0),(9,1), (8,1)]     //这里创建墙壁，两个整形的元组代表墙壁的坐标（x，y）～
        for (x,y) in initBlock {
           let be = Int(x) * 10 + Int(y)
            block[be].hidden = false
        }
        
        let initBeeper = [(5,0,4), (2,0,3)]            //这里创建Beeper！  三个整形元组，第三个数字是Beeper的堆叠数量！前两个是坐标。
        for (x,y,number) in initBeeper {
            let be = Int(x) * 10 + Int(y)
            beeperNumCount[be] = number
            beeperCount[be].stringValue = "\(beeperNumCount[be])"
            beeperCount[be].hidden = false
            beeper[be].hidden = false
        }
    }//End of initkarel
    
}

extension Karel {
//    这里是动作方法实现
  

    func move() {                                       //karel根据当前方向前进，妈蛋这个方法坑了爹好久………………
       
          sleep(UInt32(slowTime))                       //原谅我吧，我确实不会写延迟×××××谁来搞定这个？×××××××××
//        判断方向，如果不超过边界就往前一格；同时判断前方是否blocked
        switch self.direction {
        case .east where coordinate.x < 10 && block[Int(coordinate.x + 1) * 10 + Int(coordinate.y)].hidden :
            coordinate.x += 1
        case .south where coordinate.y > 0 && block[Int(coordinate.x) * 10 + Int(coordinate.y - 1)].hidden:
            coordinate.y -= 1
        case .west where coordinate.x > 0 && block[Int(coordinate.x - 1) * 10 + Int(coordinate.y)].hidden:
            coordinate.x -= 1
        case .north where coordinate.y < 10 && block[Int(coordinate.x) * 10 + Int(coordinate.y + 1)].hidden:
            coordinate.y += 1
        default:
            NSLog("哎呀！撞墙了！")
        }
      let  realcoor = getCoor.getRealCoordinate(coordinate)
        
        let x:CGFloat = realcoor.x
        let y:CGFloat =  realcoor.y
        mainQueue.addOperationWithBlock(){                  //操作GUI的代码放置在主线程，下同。
            self.frame = CGRectMake(x, y, 50, 50)
        }
        
    } //End of move()
    
    func turnLeft() {                                       //karel根据当前方向左转
     
          sleep(UInt32(slowTime))
                switch self.direction {
                case .east:
                    self.direction = .north
                    mainQueue.addOperationWithBlock(){
                        self.frameCenterRotation = 90}
                case .south:
                    self.direction = .east
                    mainQueue.addOperationWithBlock(){
                        self.frameCenterRotation = 0}
                case .west:
                    self.direction = .south
                    mainQueue.addOperationWithBlock(){
                        self.frameCenterRotation = 270}
                case .north:
                    self.direction = .west
                    mainQueue.addOperationWithBlock(){
                        self.frameCenterRotation = 180}
                    
        }
        
    }//End of turnLeft
    
    func putBeeper() {
          sleep(UInt32(slowTime))
        
      let be = Int(coordinate.x) * 10 + Int(coordinate.y)   //将抽象坐标转化为数组的标记
        if beeperNumCount[be] == 0 {                        //如果没有则放置Beeper
            beeper[be].hidden = false
            beeperCount[be].hidden = false
            beeperNumCount[be] = 1
            
        } else {                                             //如果有了就给计数器加一
        beeperNumCount[be] += 1
        }
        //最后刷新Beeper的数量显示
        beeperCount[be].stringValue = "\(beeperNumCount[be])"
        
    }//End of putBeeper
    
    func pickBeeper() {
          sleep(UInt32(slowTime)) 
        
        let be = Int(coordinate.x) * 10 + Int(coordinate.y)
        if beeperNumCount[be] == 0 {                            //如果没有就警报
            NSLog("哎呀！Beeper早没有了！")
        } else if beeperNumCount[be] == 1 {                     //如果只放了一个就清空
            beeper[be].hidden = true
            beeperCount[be].hidden = true
            beeperNumCount[be] = 0
        } else {                                                //如果有多个就把对应的计数器减一
            beeperNumCount[be] -= 1
        }
//        最后刷新显示的数字
        beeperCount[be].stringValue = "\(beeperNumCount[be])"

        
    } //End of pikBeeper

    
   

  
}