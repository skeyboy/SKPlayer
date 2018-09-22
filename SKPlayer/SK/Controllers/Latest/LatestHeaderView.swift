//
//  LatestHeaderView.swift
//  SKPlayer
//
//  Created by sk on 2018/9/20.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class LatestHeaderView: NSView {
    @IBOutlet weak var titieView: NSTextField!
    @IBInspectable var tintTextColor: NSColor = NSColor.black
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    override func layoutSubtreeIfNeeded() {
        super.layoutSubtreeIfNeeded()
//        self.titieView.textColor = self.tintTextColor
    }
    
}
