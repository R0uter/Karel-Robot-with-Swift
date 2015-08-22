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
    private var tmpCoor = NSPoint()
    private var tmpDire:Direction = .east
    
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
    
}

extension Karel {
    //    这里是动作方法实现
    
    
    func move() {                                       //karel根据当前方向前进，妈蛋这个方法坑了爹好久………………
        var b = false                                   //添加了一个是否被墙的状态
        
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

        
        let s = Stat(coordinate: coordinate, blocked: b)
        karelStat.append(s)
        
        
    } //End of move()
    
    func turnLeft() {                                       //karel根据当前方向左转
        
        
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
        
        let s = Stat(direction: direction)
        karelStat.append(s)
        
    }//End of turnLeft
    
    func putBeeper() {
        
        var stat = Stat()
        stat.beeper = 1
        karelStat.append(stat)
        
    }//End of putBeeper
    
    func pickBeeper() {
        
        var stat = Stat()
        stat.beeper = -1
        karelStat.append(stat)
        
        
    } //End of pikBeeper
    
}

extension Karel {
    
    func isBlocked() -> Bool {                                      //判断当前Karel面向是否block
        var isBlocked = false
        
        switch self.direction {
        case .east where coordinate.x == 9 || !block[Int(coordinate.x + 1) * 10 + Int(coordinate.y)].hidden :
            isBlocked = true
        case .south where coordinate.y == 0 || !block[Int(coordinate.x) * 10 + Int(coordinate.y - 1)].hidden:
            isBlocked = true
        case .west where coordinate.x == 0 || !block[Int(coordinate.x - 1) * 10 + Int(coordinate.y)].hidden:
            isBlocked = true
        case .north where coordinate.y == 9 || !block[Int(coordinate.x) * 10 + Int(coordinate.y + 1)].hidden:
            isBlocked = true
        default:
            break
        }
        
        return isBlocked
    }
    
    func isBeeperHere() -> Bool {                                   //判断当前坐标下是否有Beeper
        let be = Int(tmpCoor.x) * 10 + Int(tmpCoor.y)   //将抽象坐标转化为数组的标记
        return beeperNumCount[be] > 0
        
    }}

extension Karel {                                               //根据遍历生成好的状态序列。
    func toEnd () throws {
        for stat in karelStat {
           try checkStat(stat)
                   }
        
        
    }
    
    func checkStat (stat:Stat) throws {
        
        if  let coor = stat.coordinate {
            tmpCoor = coor
            if stat.blocked  {throw Error.duang}
            let  realcoor = stat.getRealCoordinate(coor)
            
            let x:CGFloat = realcoor.x
            let y:CGFloat =  realcoor.y
            self.frame = CGRectMake(x, y, 50, 50)
            
        }
        
        if let direction = stat.direction {
            switch direction {
            case .east:
                //                        mainQueue.addOperationWithBlock(){
                self.frameCenterRotation = 0
            case .south:
                //                        mainQueue.addOperationWithBlock(){
                self.frameCenterRotation = 270
            case .west:
                
                //                        mainQueue.addOperationWithBlock(){
                self.frameCenterRotation = 180
            case .north:
                //                        mainQueue.addOperationWithBlock(){
                self.frameCenterRotation = 90
                
            }
            
            
        }
        
        if let incr = stat.beeper {
            
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
            
        }
        
    }
    

   
    
}