//
//  HoverView.swift
//  SKPlayer
//
//  Created by sk on 2018/9/19.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
typealias HoverSelectedResponse = (HoverView, Bool)->Void
@IBDesignable
class HoverView: NSView {
    var indexPath: IndexPath?
    @IBOutlet weak var indicator: NSTextField!
    @IBInspectable  var isHovered: Bool = false {
        didSet{
             self.setNeedsDisplay(self.frame)
            if (self.hoverSelectedResponse != nil) {
                hoverSelectedResponse!(self, self.isHovered)
            }
        }
    }
    @IBInspectable var strokeHoverColor: NSColor = NSColor.lightGray
    @IBInspectable var strokeNormolColor: NSColor = NSColor.white
    
    @IBInspectable var fillHoverColor: NSColor = NSColor.lightGray
    @IBInspectable var fillNormolColor: NSColor = NSColor.white
    
    @IBInspectable var borderHoverWidth: CGFloat = 1 {
        didSet{
            self.layer?.borderWidth = self.borderHoverWidth
        }
    }
    @IBInspectable var borderNormalWidth: CGFloat = 0{
        didSet{
            self.layer?.borderWidth = self.borderNormalWidth
        }
    }
    
    var hoverSelectedResponse:HoverSelectedResponse?
    var isSelected: Bool = false{
        didSet{
            self.indicator.isHidden = !self.isSelected
            self.setNeedsDisplay(self.frame)

        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let bPath = NSBezierPath(roundedRect: self.frame,
                                 xRadius: 0, yRadius: 0)
        var fillColor: NSColor?
        var strokeColor: NSColor?
        if self.isHovered {
            fillColor = self.fillHoverColor
            strokeColor = self.strokeHoverColor
        } else {
            fillColor = self.fillNormolColor
            strokeColor = self.strokeNormolColor
        }
        if self.isSelected {
//            fillColor = NSColor.white
        }
        fillColor?.set()
        bPath.fill()
        strokeColor?.set()
    }
    override func awakeFromNib() {
        let trackArea: NSTrackingArea = NSTrackingArea(rect: self.visibleRect,
                                                       options: [NSTrackingArea.Options.activeInActiveApp, .mouseEnteredAndExited, .mouseMoved ], owner: self, userInfo: nil)
        self.addTrackingArea(trackArea)
        self.wantsLayer = true
    }
    
}
extension HoverView{
    override func mouseExited(with event: NSEvent) {
        if self.isHovered {
            self.isHovered = false
            self.borderNormalWidth = 0
        }
        super.mouseExited(with: event)
    }
    override func mouseEntered(with event: NSEvent) {
        if self.isHovered == false {
            self.isHovered = true
        }
        self.borderHoverWidth = 2
        super.mouseEntered(with: event)
    }
}
