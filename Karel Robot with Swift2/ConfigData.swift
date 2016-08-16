//
//  ConfigData.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 16/2/19.
//  Copyright © 2016年 R0uter. All rights reserved.
//

import Cocoa
import CoreData


class ConfigData: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    /// 一个读取坐标为 NSPoint 的 getter
    var pointCoordinate:NSPoint {
        get {
            let t = coordinate
            
            if let coo = t?.components(separatedBy: ","),
                let x = Double(coo[0]),
            let y = Double(coo[1]) {
                
                return NSPoint(x: Int(x), y: Int(y))
            }
            return NSPoint(x: 1, y: 1)
        }
    }
    /// 以枚举形式读取方向
    var enumDirection:Direction {
        get {
            switch self.direction! {
            case "south":
                return  .south
            case "west":
                return .west
            case "north":
                return .north
            default:
                return .east
            }
        }
        
    }
    /// 以中文形式读取和设置方向
    var chDirection:String {
        get {
        switch self.direction! {
        case "south":
            return  "朝南"
        case "west":
            return "朝西"
        case "north":
            return "朝北"
        default:
            return "朝东"
        }
        }
        
        set {
            switch newValue {
            case "朝南":
                direction =  "south"
            case "朝西":
                direction = "west"
            case "朝北":
                direction = "north"
            default:
                direction = "east"
                
            }
        }
    }
 
    
 
}
