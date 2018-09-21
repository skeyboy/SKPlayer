//
//  SKMenuViewitem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/20.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class SKMenuViewitem: NSCollectionViewItem {
    var item: SKMenuItem?{
        didSet{
            self.meneTitleView.stringValue = self.item!.title
            if self.item!.on {
                self.meneTitleView.layer?.backgroundColor = NSColor.linkColor.cgColor
                self.meneTitleView.textColor = NSColor.white
            }else {
                self.meneTitleView.layer?.backgroundColor = NSColor.white.cgColor
                self.meneTitleView.textColor = NSColor.black
            }
            
        }
    }
    @IBOutlet weak var meneTitleView: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.meneTitleView.wantsLayer = true
    }
    
}
