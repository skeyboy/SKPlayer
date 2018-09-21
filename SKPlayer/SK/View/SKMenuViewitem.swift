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
                self.view.layer?.borderWidth = 2
            }else {
                self.view.layer?.borderWidth = 0
            }
            
        }
    }
    @IBOutlet weak var meneTitleView: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.borderColor = NSColor.linkColor.cgColor
    }
    
}
