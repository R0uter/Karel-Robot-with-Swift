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
    
    private var managedObjectContext:NSManagedObjectContext!
    private(set) var direction:Direction = .east
    private(set) var coordinate:NSPoint = NSPoint(x: 0, y: 0)
    private(set) var initBlock:[(x,y)] = []
    private(set) var initBeeper:[(x,y,number)] = []
    private static var hold:Config?
    /**
     在这里覆盖配置，配置信息写在初始化器里，直接覆盖初始化器即可！
     
     direction 为Karel的朝向 分为 .east .north .south .west
     coordinate 为Karel的初始位置
     initBlock 为初始化墙壁信息，格式为[(x,y)]：[(3,3),(4,4)]
     initBeeper 为初始化Beeper信息，格式为[(x,y,number)]：[(1,1,1),(2,2,8)]
     
     */
    private init () {
        managedObjectContext = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        readConfig()
        Config.hold = self
    }
    /**
     单件模式，让 Config 永远获得唯一的实例，保证配置唯一。
     
     - returns: Config() instance
     */
    class func getConfig () -> Config {
        if let config = Config.hold {
            return config
        }
        return Config()
    }
   
    /**
     从数据库里读取配置信息，也用于刷新配置
     */
    func readConfig() {
        initBlock = []
        initBeeper = []
        
        var configDatas = getConfigData()
                /**
        *  如果数据库里没有配置，就写入一个默认的
        */
        if configDatas.isEmpty {
            resetToDefault()
            configDatas = getConfigData()
        }
        direction = configDatas[0].enumDirection
        coordinate = configDatas[0].pointCoordinate
        
        
        let blockSetContent = configDatas[0].blockSet
        let beeperSetContent = configDatas[0].beeperSet
        
        let blockSet:[String] = (blockSetContent?.componentsSeparatedByString("\n").reverse())!
        let beeperSet:[String] = (beeperSetContent?.componentsSeparatedByString("\n").reverse())!
        /**
        *  把读取到的配置提取成可以被 Karel 解析的数组，好直接与 Karel 类兼容
        */
       
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
}

// MARK: - 数据库读写函数
extension Config {
    /**
     封装的数据库读取方法，调用的还是 CoreData
     
     - returns: NSArray of ConfigData class
     */
    func getConfigData() -> [ConfigData] {
        let fetchRequest = NSFetchRequest(entityName: "ConfigData")
        var configDatas:[ConfigData] = []
        do {
            configDatas = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [ConfigData]
        } catch {
            print(error)
        }
        return configDatas
    }
    /**
     重置并初始化数据库，附带有一个默认配置
     */
    func resetToDefault() {
        let configDatas = getConfigData()
        if !configDatas.isEmpty {
            for data in configDatas {
                managedObjectContext.deleteObject(data)
            }
            try! managedObjectContext.save()
        }
        let configData = NSEntityDescription.insertNewObjectForEntityForName("ConfigData", inManagedObjectContext: managedObjectContext) as! ConfigData
        configData.beeperSet = "0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000"
        configData.blockSet = "0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000"
        configData.coordinate = "0,0"
        configData.direction = "east"
        
        try! managedObjectContext.save()
        
    }
    /**
     封装的更新数据库方法，使用的还是 CoreData 框架
     
     - parameter direction:  direction of Karel in chinese title
     - parameter coordinate: coordinate with "0,0" formate String
     - parameter blockSet:   block setting in String
     - parameter beeperSet:  beeper setting in String
     */
    func updateConfigData (direction direction:String,coordinate:String,blockSet:String,beeperSet:String) throws {
        
        let configReg = "^(\\d{10}\\n){9}\\d{10}$"
        let coorReg = "^\\d,\\d$"
        
        guard blockSet =~ configReg && beeperSet =~ configReg else {
            throw Error.configError
        }
        guard coordinate =~ coorReg else {
            throw Error.configError
        }
        
        let configData = getConfigData()[0]
        
        configData.chDirection = direction
        configData.coordinate = coordinate
        configData.blockSet = blockSet
        configData.beeperSet = beeperSet
        
        do {
            try managedObjectContext?.save()
        } catch {
            NSLog("database update error")
        }
        
    }

}
