//
//  SelectedView.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class SelectedView: NSView {
    var isSelected: Bool = false{
        didSet{
            self.setNeedsDisplay(self.visibleRect)
        }
    }
    override func awakeFromNib() {
        let trackArea: NSTrackingArea = NSTrackingArea(rect: self.visibleRect,
                                                       options: [NSTrackingArea.Options.activeInActiveApp, .mouseEnteredAndExited, .mouseMoved ], owner: self, userInfo: nil)
        self.addTrackingArea(trackArea)
    }
    override func mouseExited(with event: NSEvent) {
        self.isSelected = false
    }
    override func mouseEntered(with event: NSEvent) {
        self.isSelected = true
    }
    override func draw(_ dirtyRect: NSRect) {

        // Drawing code here.
        let bPath = NSBezierPath(roundedRect: self.bounds,
                                 xRadius: 0, yRadius: 0)
        var fillColor: NSColor?
        var strokeColor: NSColor?
        if self.isSelected {
            fillColor = NSColor.gray
            strokeColor = NSColor.magenta
        } else {
            fillColor = NSColor.white
            strokeColor = NSColor.red
        }
        fillColor?.set()
        bPath.fill()
        strokeColor?.set()
        super.draw(dirtyRect)

    }
    
}
