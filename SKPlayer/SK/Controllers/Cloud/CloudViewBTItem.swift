//
//  CloudViewBTItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/12.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class CloudViewBTItem: NSCollectionViewItem {
    var player: CloudPlayer? {
        didSet{
            self.itemView.stringValue = player?.title ?? "未知"
        }
    }
    @IBOutlet weak var itemView: NSTextField!
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.wantsLayer = true
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor.lightGray.cgColor
        
    }
    
}
