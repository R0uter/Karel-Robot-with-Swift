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
    
    private var beeperNumCount = [Int](count: 100, repeatedValue: 0)        //储存 Beeper 的堆叠数量
    private var coordinate:NSPoint = NSPoint(x: 0, y: 0) //karel 的当前坐标位置
    private var direction:Direction = .east //朝向
    private var getCoor = Coordinate()      //用来换算真实坐标的
    private var tmpCoor = NSPoint()     //用来撸状态时串联坐标用的临时变量
    private var tmpDire:Direction = .east       //临时方向，用途如上
    
    
    var getDirection:Direction {                        //这是个getter，我尝试用计算属性来搞定这件事情。但是问题在于我忘了哪里用过它了。——反正就留着吧：）
        get {
            return direction
        }
    } //End of getDirection
    
    
    func beeperNumClean() {
        beeperNumCount.removeAll()
        beeperNumCount = [Int](count: 100, repeatedValue: 0)
    }
 
    
    
   func initKarel () {                                 //初始化一个karel，我懒得写初始化器了，直接写个函数完事。
        coordinate = NSPoint(x: 0, y: 0)                //设定Karel坐标
        direction = .east                              //设定初始化Karel方向
        
        switch self.direction {                         //根据方向初始化Karel
        case .north:
            self.frameCenterRotation = 90
        case .east:
            self.frameCenterRotation = 0
        case .south:
            self.frameCenterRotation = 270
        case .west:
            self.frameCenterRotation = 180
            
        }
        
        
        let rect =  getCoor.getRealCoordinate(coordinate)
        self.frame = CGRectMake(rect.x, rect.y, 50, 50)
        self.image = NSImage(named: "karel")
    }//End of initkarel()
    
    
    
    func initBlockAndBeeper() {                         //cxxxxxx{}=======> 如果要创建地图则在这里修改坐标即可！××××××××
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
    
}//Karel 结束



extension Karel {       //    这里把你写好的动作转换成静态的状态存到数组当中去。
    
    
    func move() {          //karel根据当前方向前进，妈蛋这个方法坑了爹好久………………
        var b = false       //添加了一个是否被墙的状态
        
        switch direction {
            case .east where coordinate.x < 10 && block[Int(coordinate.x + 1) * 10 + Int(coordinate.y)].hidden :
                coordinate.x += 1
            case .south where coordinate.y > 0 && block[Int(coordinate.x) * 10 + Int(coordinate.y - 1)].hidden:
                coordinate.y -= 1
            case .west where coordinate.x > 0 && block[Int(coordinate.x - 1) * 10 + Int(coordinate.y)].hidden:
                coordinate.x -= 1
            case .north where coordinate.y < 10 && block[Int(coordinate.x) * 10 + Int(coordinate.y + 1)].hidden:
                coordinate.y += 1
            default:
                b = true
        }

//        把一个状态压入数组
        let s = Stat(coordinate: coordinate, blocked: b)
        karelStat.append(s)
        
    } //End of move()
    
    
    
    func turnLeft() {         //karel根据当前方向左转
        
        switch self.direction {
            case .east:
                self.direction = .north
            case .south:
                self.direction = .east
            case .west:
                self.direction = .south
            case .north:
                self.direction = .west
        }

        let s = Stat(direction: direction)//        把状态压入数组
        karelStat.append(s)
        
    }//End of turnLeft
    
    
    func putBeeper() {
        
        var stat = Stat()
        stat.beeper = 1
        karelStat.append(stat)      //把动作压入数组
        
    }//End of putBeeper
    
    func pickBeeper() {
        
        var stat = Stat()
        stat.beeper = -1
        karelStat.append(stat)      //把动作压入数组
        
        
    } //pikBeeper 结束
    
}//扩展结束

extension Karel {           //根据遍历生成好的状态序列。

    
    func checkStat (stat:Stat) throws {     //标记方法是有风险的，撞墙的时候会抛出错误，直接传给 ViewController
        
        if  let coor = stat.coordinate {        //如果状态当中保存了坐标信息就执行
            tmpCoor = coor
            if stat.blocked  {throw Error.duang}
            let  realcoor = stat.getRealCoordinate(coor)
            
            let x:CGFloat = realcoor.x
            let y:CGFloat =  realcoor.y
            self.frame = CGRectMake(x, y, 50, 50)
            
        }//坐标操作结束
        
        if let direction = stat.direction {     //如果状态当中保存了方向信息就执行
            switch direction {
            case .east:
                self.frameCenterRotation = 0
            case .south:
                self.frameCenterRotation = 270
            case .west:
                self.frameCenterRotation = 180
            case .north:
                self.frameCenterRotation = 90
            }
            
        }//方向操作结束
        
        if let incr = stat.beeper {     //如果状态当中保存了对Beeper的操作就执行
            
            let be = Int(tmpCoor.x) * 10 + Int(tmpCoor.y)
            if (beeperNumCount[be] + incr) >= 0 {
                beeperNumCount[be] += incr
                if beeperNumCount[be] > 0 {                        //如果没有则放置Beeper
                    beeper[be].hidden = false
                    beeperCount[be].hidden = false
                } else {
                    beeper[be].hidden = true
                    beeperCount[be].hidden = true
                }
                //                                最后刷新Beeper的数量显示
                beeperCount[be].stringValue = "\(beeperNumCount[be])"
                
                
                
            }
            
        }//Beeperc操作结束
        
    }//checkStat 结束
}//扩展结束