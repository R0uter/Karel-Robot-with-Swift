//
//  test.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 16/2/20.
//  Copyright © 2016年 R0uter. All rights reserved.
//

import Cocoa

class TextField: NSTextField {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        let editor = currentEditor()
        editor?.fieldEditor = false
    }
}