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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
