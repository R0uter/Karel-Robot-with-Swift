//
//  Config.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 16/2/1.
//  Copyright © 2016年 R0uter. All rights reserved.
//

import Cocoa
/**
 *  在这里设置 Karel 的初始位置信息，比如朝向，比如坐标，比如Beeper和Block。
 */
class Config {
    typealias x = Int
    typealias y = Int
    typealias number = Int
    
    private var direction:Direction = .east
    private var coordinate:NSPoint = NSPoint(x: 0, y: 0)
    private var initBlock:[(x,y)] = []
    private var initBeeper:[(x,y,number)] = []
    private static var hold:Config?
    /**
     在这里覆盖配置，配置信息写在初始化器里，直接覆盖初始化器即可！
     
     direction 为Karel的朝向 分为 .east .north .south .west
     coordinate 为Karel的初始位置
     initBlock 为初始化墙壁信息，格式为[(x,y)]：[(3,3),(4,4)]
     initBeeper 为初始化Beeper信息，格式为[(x,y,number)]：[(1,1,1),(2,2,8)]
     
     */
    private init () {
        direction = .east
        coordinate = NSPoint(x: 0, y: 0)
        readConfig()
        Config.hold = self
    }
    class func getConfig () -> Config {
        if let config = Config.hold {
            return config
        }
        return Config()
    }
    func setBlock (config:String) {
        
    }
    func setBeeper (config:String) {
      
        
    }
    func readConfig() {
        initBlock = []
        initBeeper = []
        let path = NSBundle.mainBundle().bundlePath + "/Contents/Resources/"
        let blockSetContent = try? String(contentsOfFile: path + "BlockSet",encoding: NSUTF8StringEncoding)
        let beeperSetContent = try? String(contentsOfFile: path + "BeeperSet", encoding: NSUTF8StringEncoding)
        
        let blockSet:[String] = (blockSetContent?.componentsSeparatedByString("\n").reverse())!
        let beeperSet:[String] = (beeperSetContent?.componentsSeparatedByString("\n").reverse())!
        
        for y in 0...9 {
            let blockRow = blockSet[y]
            let beeperRow = beeperSet[y]
            for x in 0...9 {
                let index = blockRow.characters.startIndex.advancedBy(x)
                let n = Int(String(blockRow.characters[index]))!
                if n != 0 {
                initBlock.append((x,y))
                }
                let bindex = beeperRow.characters.startIndex.advancedBy(x)
                let bn = Int(String(beeperRow.characters[bindex]))!
                if bn != 0 {
                initBeeper.append((x,y,bn))
                }
            }
        }
        
        
    }
}//这里创建Beeper！  三个整形元组，第三个数字是Beeper的堆叠数量！前两个是坐标。


// MARK: - 写一堆getter
extension Config {
    var getDirection:Direction {
        return direction
    }
    var getCoordinate:NSPoint {
        return coordinate
    }
    var getInitBlock:[(Int,Int)] {
        return initBlock
    }
    var getInitBeeper:[(Int,Int,Int)] {
        return initBeeper
    }
}