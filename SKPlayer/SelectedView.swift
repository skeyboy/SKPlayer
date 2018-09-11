//
//  SelectedView.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
typealias SelectedViewCallback = (Bool)->Void
class SelectedView: NSView {
    
    var callBack:SelectedViewCallback?
    var isHover:Bool = false {
        didSet{
            if (callBack != nil) {
                callBack!(isSelected)
            }
            self.setNeedsDisplay(self.bounds)
        }
    }
    var isSelected: Bool = false{
        didSet{
            if (callBack != nil) {
                callBack!(isSelected)
            }
            self.setNeedsDisplay(self.visibleRect)
        }
    }
    override func awakeFromNib() {
        let trackArea: NSTrackingArea = NSTrackingArea(rect: self.visibleRect,
                                                       options: [NSTrackingArea.Options.activeInActiveApp, .mouseEnteredAndExited, .mouseMoved ], owner: self, userInfo: nil)
        self.addTrackingArea(trackArea)
    }
    override func mouseExited(with event: NSEvent) {
        
        self.isHover = false
    }
    override func mouseEntered(with event: NSEvent) {
        if self.isHover == false{
            self.isHover = true
            
        }
    }
    override func mouseMoved(with event: NSEvent) {
        
    }
    override func draw(_ dirtyRect: NSRect) {

        // Drawing code here.
        let bPath = NSBezierPath(roundedRect: self.bounds,
                                 xRadius: 0, yRadius: 0)
        var fillColor: NSColor?
        var strokeColor: NSColor?
        if self.isSelected  || isHover{
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
