//
//  RegexHelper.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 16/2/20.
//  Copyright © 2016年 R0uter. All rights reserved.
//

import Foundation
/**
 *  正则表达式的实现，重载了 =~ 运算符来匹配正则，代码是抄来的，swifter
 */
struct RegexHelper {
    
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        
    try regex = NSRegularExpression(pattern: pattern,options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        
    let matches = regex.matches(in: input,options: [],range: NSMakeRange(0, input.characters.count))
        
    return matches.count > 0
        
    }
}

infix operator =~ {
    associativity none
    precedence 130
}

func =~ (lhs: String, rhs: String) -> Bool {
    do {
            return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}
