//
//  SelectedView.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
typealias SelectedViewCallback = (Bool)->Void

protocol Shakeable {
    
}

extension Shakeable where Self: NSView{
    func shake(offSet: Float? = 5, repeatCount: Float? = 2, duration: CFTimeInterval? = 0.05) -> Void {
        layer?.removeAnimation(forKey: "position")
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration!
        animation.repeatCount = repeatCount!
        animation.autoreverses = true
        animation.fromValue = NSValue.init(point: NSPoint(x: CGFloat(self.center.x - CGFloat(offSet!)), y: self.center.y))
        animation.toValue = NSValue.init(point: NSPoint(x: CGFloat(self.center.x +
            CGFloat(offSet!)), y: self.center.y))
        layer?.add(animation, forKey: "pasition")
    }
}
protocol Hoverable {
    
}

extension NSView{
    var center: CGPoint{
        let centerX =  (self.frame.origin.x + self.frame.width)/2
        let centerY = (self.frame.origin.y + self.frame.height)/2
        return CGPoint(x: centerX, y: centerY)
    }
}

class SelectedView: NSView {
    
    var callBack:SelectedViewCallback?
    var isHover:Bool = false {
        didSet{
            
            if (callBack != nil) {
                callBack!(isSelected)
            }
            self.setNeedsDisplay(self.frame)
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
            self.shake()
        }
    }
    override func mouseMoved(with event: NSEvent) {
        
    }
    override func draw(_ dirtyRect: NSRect) {
        
        // Drawing code here.
        let bPath = NSBezierPath(roundedRect: self.frame,
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

extension SelectedView : Shakeable{}
