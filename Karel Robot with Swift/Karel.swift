//
//  karel.swift
//  karel Robot
//
//  Created by R0uter on 15/7/29.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Cocoa

class Karel: NSImageView {
    fileprivate var beeperNumCount = [Int](repeating: 0, count: 100) // 储存 Beeper 的堆叠数量
    fileprivate var coordinate: NSPoint = NSPoint(x: 0, y: 0) // karel 的当前坐标位置
    fileprivate var direction: Direction = .east // 朝向
    fileprivate var getCoor = Coordinate() // 用来换算真实坐标的
    fileprivate var tmpCoor = NSPoint() // 用来撸状态时串联坐标用的临时变量
    fileprivate var tmpDire: Direction = .east // 临时方向，用途如上
    fileprivate let config = Config() // 加载一堆配置信息
    var step = 0 // 储存遍历的进度
    
    /// 这是个getter，我尝试用计算属性来搞定这件事情,用来给坐标换算使用。
    var getDirection: Direction {
        return direction
    } // End of getDirection
    
    func beeperNumClean() {
        beeperNumCount.removeAll()
        beeperNumCount = [Int](repeating: 0, count: 100)
    }
    
    /**
     根据配置信息初始化 Karel ,配置文件在 Config 结构体里！
     */
    func initKarel() {
        direction = config.getDirection
        switch direction { // 根据方向初始化Karel
            case .north:
                frameCenterRotation = 90
            case .east:
                frameCenterRotation = 0
            case .south:
                frameCenterRotation = 270
            case .west:
                frameCenterRotation = 180
        }
        coordinate = config.getCoordinate
        let rect = getCoor.getRealCoordinate(coordinate)
        frame = CGRect(x: rect.x, y: rect.y, width: 50, height: 50)
        image = NSImage(named: "karel")?.tint(color: .textColor)
    } // End of initkarel()
    
    /**
     Block 和 Beeper 初始化,配置文件在 Config 结构体里！
     
     - returns: 无返回值
     */
    func initBlockAndBeeper() {
        for (x, y) in config.getInitBlock {
            let be = Int(x) * 10 + Int(y)
            block[be].isHidden = false
        }
        for (x, y, number) in config.getInitBeeper {
            let be = Int(x) * 10 + Int(y)
            beeperNumCount[be] = number
            beeperCount[be].stringValue = "\(beeperNumCount[be])"
            beeperCount[be].isHidden = false
            beeper[be].isHidden = false
        }
    } // End of initkarel
} // Karel 结束

// MARK: - 功能实现部分

extension Karel {
    /**
     判断Karel是否被墙
     
     - returns: 返回布尔值true为墙了，false则是没有被阻挡
     */
    func karelIsBlocked() -> Bool {
        var b = false
        DispatchQueue.main.sync {
            switch direction {
                case .east where coordinate.x < 9 && block[Int(coordinate.x + 1) * 10 + Int(coordinate.y)].isHidden:
                    break
                case .south where coordinate.y > 0 && block[Int(coordinate.x) * 10 + Int(coordinate.y - 1)].isHidden:
                    break
                case .west where coordinate.x > 0 && block[Int(coordinate.x - 1) * 10 + Int(coordinate.y)].isHidden:
                    break
                case .north where coordinate.y < 9 && block[Int(coordinate.x) * 10 + Int(coordinate.y + 1)].isHidden:
                    break
                default:
                    b = true
            }
        }
        
        return b
    }
    
    /**
     判断Karel脚下有没有beeper
     
     - returns: 有就true，没有就false
     */
    func karelIsBeeperHere() -> Bool {
        let be = Int(coordinate.x) * 10 + Int(coordinate.y)
        var b = false
        if beeperNumCount[be] > 0 {
            b = true
        }
        return b
    }
    
    /**
     karel根据当前方向前进
     
     */
    func KarelMove() throws {
        switch direction {
            case .east where coordinate.x < 9 && block[Int(coordinate.x + 1) * 10 + Int(coordinate.y)].isHidden:
                coordinate.x += 1
            case .south where coordinate.y > 0 && block[Int(coordinate.x) * 10 + Int(coordinate.y - 1)].isHidden:
                coordinate.y -= 1
            case .west where coordinate.x > 0 && block[Int(coordinate.x - 1) * 10 + Int(coordinate.y)].isHidden:
                coordinate.x -= 1
            case .north where coordinate.y < 9 && block[Int(coordinate.x) * 10 + Int(coordinate.y + 1)].isHidden:
                coordinate.y += 1
            default:
                throw KarelError.duang
        }
        let realcoor = getCoor.getRealCoordinate(coordinate)
        
        let x: CGFloat = realcoor.x
        let y: CGFloat = realcoor.y
        
        frame = CGRect(x: x, y: y, width: 50, height: 50)
    } // End of move()
    
    /**
     karel根据当前方向左转
     */
    func KarelTurnLeft() {
        switch direction {
            case .east:
                direction = .north
            case .south:
                direction = .east
            case .west:
                direction = .south
            case .north:
                direction = .west
        }
        
        switch direction { // 根据转了的方向更新frame
            case .east:
                frameCenterRotation = 0
            case .south:
                frameCenterRotation = 270
            case .west:
                frameCenterRotation = 180
            case .north:
                frameCenterRotation = 90
        }
    } // End of turnLeft
    
    func KarelPutBeeper() {
        let be = Int(coordinate.x) * 10 + Int(coordinate.y)
        //    mainQueue.addOperationWithBlock() {
        if (beeperNumCount[be] + 1) >= 0 {
            beeperNumCount[be] += 1
            // 如果没有则放置Beeper
            beeper[be].isHidden = false
            beeperCount[be].isHidden = false
        }
        // 最后刷新Beeper的数量显示
        beeperCount[be].stringValue = "\(beeperNumCount[be])"
        // }
    } // End of putBeeper
    
    func KarelPickBeeper() throws {
        let be = Int(coordinate.x) * 10 + Int(coordinate.y)
        
        if (beeperNumCount[be] - 1) >= 0 {
            beeperNumCount[be] -= 1
            if beeperNumCount[be] == 0 {
                beeper[be].isHidden = true
                beeperCount[be].isHidden = true
            }
        } else {
            throw KarelError.noBeeper
        }
        // 最后刷新Beeper的数量显示
        beeperCount[be].stringValue = "\(beeperNumCount[be])"
    } // pikBeeper 结束
} // 扩展结束

// MARK: - 新的实现karel行动的方法

extension Karel {
    func check() {
        while isPaused {
            Thread.sleep(forTimeInterval: 0.5)
        }
        Thread.sleep(forTimeInterval: slowTime)
    }
    
    /// 包装一下方法名称，给run用。
    func move() {
        if backgroundQueue.isSuspended {
            return
        }
        check()
        if backgroundQueue.isSuspended {
            return
        }
        mainQueue.addOperation {
            do {
                try self.KarelMove()
            } catch KarelError.duang {
                error.setError(KarelError.duang)
                backgroundQueue.isSuspended = true
            } catch {
                NSLog("move() throws a unknowen eror")
            }
        }
    }
    
    func turnLeft() {
        if backgroundQueue.isSuspended {
            return
        }
        check()
        if backgroundQueue.isSuspended {
            return
        }
        mainQueue.addOperation {
            self.KarelTurnLeft()
        }
    }
    
    func putBeeper() {
        if backgroundQueue.isSuspended {
            return
        }
        check()
        if backgroundQueue.isSuspended {
            return
        }
        mainQueue.addOperation {
            self.KarelPutBeeper()
        }
    }
    
    func pickBeeper() {
        if backgroundQueue.isSuspended {
            return
        }
        check()
        if backgroundQueue.isSuspended {
            return
        }
        mainQueue.addOperation {
            do {
                try self.KarelPickBeeper()
            } catch KarelError.noBeeper {
                error.setError(KarelError.noBeeper)
                backgroundQueue.isSuspended = true
            } catch {
                NSLog("pickBeeper throws a unknowen eror")
            }
        }
    }
    
    func isBlocked() -> Bool {
        if backgroundQueue.isSuspended {
            return true
        }
        check()
        if backgroundQueue.isSuspended {
            return true
        }
        return karelIsBlocked()
    }
    
    func isBeeperHere() -> Bool {
        if backgroundQueue.isSuspended {
            return true
        }
        check()
        if backgroundQueue.isSuspended {
            return true
        }
        return karelIsBeeperHere()
    }
}
