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
        
        // 1
        view.layer?.borderColor = NSColor.yellow.cgColor
        // 2
        view.layer?.borderWidth = 0.0
    }
    
}
