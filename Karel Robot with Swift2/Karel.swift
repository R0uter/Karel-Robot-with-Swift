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
    private var cmdArr:[()throws ->()] = []    //储存命令序列
    var step = 0 //储存遍历的进度
    
    
    var getDirection:Direction {                        //这是个getter，我尝试用计算属性来搞定这件事情,用来给坐标换算使用。
        get {
            return direction
        }
    } //End of getDirection
    
    
    func beeperNumClean() {
        beeperNumCount.removeAll()
        beeperNumCount = [Int](count: 100, repeatedValue: 0)
    }
 

    
   func initKarel() {                                 //初始化一个karel，我懒得写初始化器了，直接写个函数完事。
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
    
    
    func KarelMove() throws{          //karel根据当前方向前进，妈蛋这个方法坑了爹好久………………

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
                throw Error.duang
        }
        let  realcoor = getCoor.getRealCoordinate(coordinate)
        
        let x:CGFloat = realcoor.x
        let y:CGFloat =  realcoor.y
        self.frame = CGRectMake(x, y, 50, 50)
        
    } //End of move()
    
    
    
    func KarelTurnLeft() throws{         //karel根据当前方向左转
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
        switch direction {//根据转了的方向更新frame
            case .east:
                self.frameCenterRotation = 0
            case .south:
                self.frameCenterRotation = 270
            case .west:
                self.frameCenterRotation = 180
            case .north:
                self.frameCenterRotation = 90
        }


        
    }//End of turnLeft
    
    
    func KarelPutBeeper() throws {
        
        let be = Int(coordinate.x) * 10 + Int(coordinate.y)
        if (beeperNumCount[be] + 1) >= 0 {
            beeperNumCount[be] += 1
             //如果没有则放置Beeper
                beeper[be].hidden = false
                beeperCount[be].hidden = false
            }
            // 最后刷新Beeper的数量显示
            beeperCount[be].stringValue = "\(beeperNumCount[be])"
    }//End of putBeeper
    
    func KarelPickBeeper()  throws {

        let be = Int(coordinate.x) * 10 + Int(coordinate.y)
        if (beeperNumCount[be] - 1) >= 0 {
            beeperNumCount[be] -= 1
            if beeperNumCount[be] == 0 {                        //如果没有则放置Beeper
                beeper[be].hidden = true
                beeperCount[be].hidden = true
            }
        }
            //                                最后刷新Beeper的数量显示
            beeperCount[be].stringValue = "\(beeperNumCount[be])"      
    } //pikBeeper 结束
    
}//扩展结束

extension Karel { //新的实现karel行动的方法
    func process() throws{
        if step < cmdArr.count { //依次执行方法引用
           try cmdArr[step]()
            ++step
        } else {
            throw Error.eof
        }
    }
    
    //包装一下方法名称，给run用。
    func move() {
        cmdArr.append(KarelMove)
    }
    func turnLeft() {
        cmdArr.append(KarelTurnLeft)
    }
    func putBeeper() {
        cmdArr.append(KarelPutBeeper)
    }
    func pickBeeper() {
        cmdArr.append(KarelPickBeeper)
    }
}
