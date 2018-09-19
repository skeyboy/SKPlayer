//
//  SelectedView.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
typealias SelectedViewCallback = (Bool)->Void
@objc
protocol Shakeable {
   @objc optional func shakeBegin() -> Void
 @objc   optional  func shakeEnd() ->Void
}

extension Shakeable where Self: NSView{
    func shake(offSet: Float? = 2, repeatCount: Float? = 2, duration: CFTimeInterval? = 0.05) -> Void {
        layer?.removeAnimation(forKey: "position")
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration!
        animation.repeatCount = repeatCount!
        animation.autoreverses = true
        animation.fromValue = NSValue.init(point: NSPoint(x: CGFloat(self.center.x - CGFloat(offSet!)), y: self.center.y))
        if let shakeBegin =  shakeBegin{
            shakeBegin()
        }
        animation.toValue = NSValue.init(point: NSPoint(x: CGFloat(self.center.x +
            CGFloat(offSet!)), y: self.center.y))
        if let shakeEnd = shakeEnd {
            shakeEnd()
        }
        layer?.add(animation, forKey: "pasition")
    }
}
protocol Hoverable {
    
}

extension NSView{
    var center: CGPoint{
        let centerX =  (self.bounds.origin.x + self.bounds.width)/2
        let centerY = (self.bounds.origin.y + self.bounds.height)/2
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
        self.wantsLayer = true
        self.layer?.borderColor = NSColor.magenta.cgColor

    }
    override func mouseExited(with event: NSEvent) {
        
        self.isHover = false
        self.layer?.borderWidth = 0

    }
    override func mouseEntered(with event: NSEvent) {
        if self.isHover == false{
            self.isHover = true
             self.shake()
        }
        self.layer?.borderWidth = 2
    }
    override func mouseMoved(with event: NSEvent) {
        
    }
    override func draw(_ dirtyRect: NSRect) {
        
        // Drawing code here.
        let bPath = NSBezierPath(roundedRect: self.frame,
                                 xRadius: 0, yRadius: 0)
        var fillColor: NSColor?
        var strokeColor: NSColor?
        if self.isHover {
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
extension NSRect{
    func scale(_ scale: Int) -> NSRect {
     return   NSRect(x: Int(self.origin.x ) , y: Int(self.origin.y), width: Int(self.size.width) + scale, height: Int(self.size.height) + scale)
    }
    func diss(_ diss: Int) -> NSRect {
        return scale(_:-diss)
    }
}
