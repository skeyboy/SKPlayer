//
//  IndexHeaderView.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class IndexHeaderView: SelectedView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor(calibratedWhite: 0.8 , alpha: 0.8).set()
     }
    @IBOutlet weak var indexSectionHeaderView: NSTextField!
    
}

