//
//  test.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 16/2/20.
//  Copyright © 2016年 R0uter. All rights reserved.
//

import Cocoa

class TextField: NSTextField {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let editor = currentEditor()
        editor?.isFieldEditor = false
    }
}
