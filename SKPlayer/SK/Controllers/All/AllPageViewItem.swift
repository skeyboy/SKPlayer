//
//  AllPageViewItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/22.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
extension NSColor{
    open class var  linkColor: NSColor{
        return NSColor.lightGray
    }
}
class AllPageViewItem: NSCollectionViewItem {
    var pageItem: PageItem?{
        didSet{
            if let pageItem = self.pageItem {
                self.pageView.stringValue = pageItem.title
                self.view.layer?.backgroundColor = pageItem.on ? NSColor.linkColor.cgColor : NSColor.white.cgColor
            }
            
        }
    }
    @IBOutlet weak var pageView: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        
    }
    
}
