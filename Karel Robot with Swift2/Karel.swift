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
    private var tmpDire:Direction = .east       //临时方向，用途如上
    private let config = Config.getConfig()   //加载一堆配置信息
    var step = 0 //储存遍历的进度
    
    ///这是个getter，我尝试用计算属性来搞定这件事情,用来给坐标换算使用。
    var getDirection:Direction {
        get {
            return direction
        }
    } //End of getDirection
    
    
    func beeperNumClean() {
        beeperNumCount.removeAll()
        beeperNumCount = [Int](count: 100, repeatedValue: 0)
    }
 
    
    /**
     根据配置信息初始化 Karel ,配置文件在 Config 结构体里！
     */
   func initKarel() {
        direction = config.getDirection
        switch direction {  //根据方向初始化Karel
        case .north:
            self.frameCenterRotation = 90
        case .east:
            self.frameCenterRotation = 0
        case .south:
            self.frameCenterRotation = 270
        case .west:
            self.frameCenterRotation = 180
        }
        coordinate = config.getCoordinate
        let rect = getCoor.getRealCoordinate(coordinate)
        self.frame = CGRectMake(rect.x, rect.y, 50, 50)
        self.image = NSImage(named: "karel")
    }//End of initkarel()
    
    /**
    Block 和 Beeper 初始化,配置文件在 Config 结构体里！
    
    - returns: 无返回值
    */
    func initBlockAndBeeper() {
        for (x,y) in config.getInitBlock {
            let be = Int(x) * 10 + Int(y)
            block[be].hidden = false
        }
        for (x,y,number) in config.getInitBeeper {
            let be = Int(x) * 10 + Int(y)
            beeperNumCount[be] = number
            beeperCount[be].stringValue = "\(beeperNumCount[be])"
            beeperCount[be].hidden = false
            beeper[be].hidden = false
        }
    }//End of initkarel
}//Karel 结束


// MARK: - 功能实现部分
extension Karel {
    /**
     判断Karel是否被墙
     
     - returns: 返回布尔值true为墙了，false则是没有被阻挡
     */
    func karelIsBlocked() ->Bool {
        var b = false
        switch direction {
        case .east where coordinate.x < 9 && block[Int(coordinate.x + 1) * 10 + Int(coordinate.y)].hidden :
            break
        case .south where coordinate.y > 0 && block[Int(coordinate.x) * 10 + Int(coordinate.y - 1)].hidden:
            break
        case .west where coordinate.x  > 0 && block[Int(coordinate.x - 1) * 10 + Int(coordinate.y)].hidden:
            break
        case .north where coordinate.y < 9 && block[Int(coordinate.x) * 10 + Int(coordinate.y + 1)].hidden:
            break
        default:
            b = true
        }
        return b
        
    }
    /**
     判断Karel脚下有没有beeper
     
     - returns: 有就true，没有就false
     */
    func karelIsBeeperHere() ->Bool {
        
        let be = Int(coordinate.x) * 10 + Int(coordinate.y)
        var b = false
        if self.beeperNumCount[be]  > 0 {
            b = true
            }
        return b    
    }
    
    /**
    karel根据当前方向前进
     
    */
    func KarelMove() throws{
        
        switch direction {
            case .east where coordinate.x < 9 && block[Int(coordinate.x + 1) * 10 + Int(coordinate.y)].hidden :
                coordinate.x += 1
            case .south where coordinate.y > 0 && block[Int(coordinate.x) * 10 + Int(coordinate.y - 1)].hidden:
                coordinate.y -= 1
            case .west where coordinate.x > 0 && block[Int(coordinate.x - 1) * 10 + Int(coordinate.y)].hidden:
                coordinate.x -= 1
            case .north where coordinate.y < 9 && block[Int(coordinate.x) * 10 + Int(coordinate.y + 1)].hidden:
                coordinate.y += 1
            default:
                throw Error.duang
        }
        let  realcoor = getCoor.getRealCoordinate(coordinate)
        
        let x:CGFloat = realcoor.x
        let y:CGFloat =  realcoor.y
       
        self.frame = CGRectMake(x, y, 50, 50)
           
    } //End of move()
    
    
    /**
    karel根据当前方向左转
    */
    func KarelTurnLeft(){
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
       
        switch self.direction {//根据转了的方向更新frame
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
    
    
    func KarelPutBeeper() {
        
        let be = Int(coordinate.x) * 10 + Int(coordinate.y)
    //    mainQueue.addOperationWithBlock() {
        if (self.beeperNumCount[be] + 1) >= 0 {
            self.beeperNumCount[be] += 1
             //如果没有则放置Beeper
                beeper[be].hidden = false
                beeperCount[be].hidden = false
            }
            // 最后刷新Beeper的数量显示
            beeperCount[be].stringValue = "\(self.beeperNumCount[be])"
        //}
        
    }//End of putBeeper
    
    func KarelPickBeeper()  throws {

        let be = Int(coordinate.x) * 10 + Int(coordinate.y)
        
        if (self.beeperNumCount[be] - 1) >= 0 {
            self.beeperNumCount[be] -= 1
            if self.beeperNumCount[be] == 0 {
                beeper[be].hidden = true
                beeperCount[be].hidden = true
            }
        } else {
            throw Error.noBeeper
        }
            //最后刷新Beeper的数量显示
            beeperCount[be].stringValue = "\(self.beeperNumCount[be])"
        
        
    } //pikBeeper 结束
    
}//扩展结束

// MARK: - 新的实现karel行动的方法
extension Karel {
    func check() {
        
        while isPaused {
            NSThread.sleepForTimeInterval(0.5)
        }
        NSThread.sleepForTimeInterval(slowTime)
    }
   
    ///包装一下方法名称，给run用。
    func move() {
        
        if backgroundQueue.suspended {
            return
        }
        check()
        if backgroundQueue.suspended {
            return
        }
                mainQueue.addOperationWithBlock(){
       
            do {
            try self.KarelMove()
            } catch Error.duang {
                error.setError(Error.duang)
                backgroundQueue.suspended = true
            } catch {
                NSLog("move() throws a unknowen eror")
            }
        }
    }
    func turnLeft() {
        if backgroundQueue.suspended {
            return
        }
        check()
        if backgroundQueue.suspended {
            return
        }
        mainQueue.addOperationWithBlock(){
        self.KarelTurnLeft()
        }
    }
    func putBeeper() {
        if backgroundQueue.suspended {
            return
        }
        check()
        if backgroundQueue.suspended {
            return
        }
        mainQueue.addOperationWithBlock(){
        
         self.KarelPutBeeper()
        }
    }
    func pickBeeper() {
        if backgroundQueue.suspended {
            return
        }
        check()
        if backgroundQueue.suspended {
            return
        }
        mainQueue.addOperationWithBlock(){
      
            do {
                try self.KarelPickBeeper()
            } catch Error.noBeeper {
                error.setError(Error.noBeeper)
                backgroundQueue.suspended = true
            } catch {
                NSLog("pickBeeper throws a unknowen eror")
            }

        }
    }
    func isBlocked()->Bool {
        if backgroundQueue.suspended {
            return true
        }
        check()
        if backgroundQueue.suspended {
            return true
        }
        return karelIsBlocked()
       
    }
    func isBeeperHere()->Bool {
        if backgroundQueue.suspended {
            return true
        }
        check()
        if backgroundQueue.suspended {
            return true
        }
        return   karelIsBeeperHere()
        
    }
}
