//
//  RateViewItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/28.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class RateViewItem: NSCollectionViewItem {
    @IBOutlet weak var focusView: NSView!
    
    @IBOutlet weak var nameView: NSTextField!
    @IBOutlet weak var emView: NSTextField!
    @IBOutlet weak var ageView: NSTextField!
    @IBOutlet weak var areaView: NSTextField!
    @IBOutlet weak var scoreView: NSTextField!
    @IBOutlet weak var typeView: NSTextField!
    @IBOutlet weak var starringView: NSTextField!
    @IBOutlet weak var timetitView: NSTextField!
    var rate: Rate? {
        didSet{
            if let rate = rate {
                self.nameView.stringValue = rate.title ?? UnKnown
                self.emView.stringValue = rate.em ?? UnKnown
                self.ageView.stringValue = rate.year ?? UnKnown
                self.areaView.stringValue = rate.area ?? UnKnown
                self.scoreView.stringValue = rate.score ?? UnKnown
                self.typeView.stringValue = rate.type ?? UnKnown
                self.starringView.stringValue = rate.starring ?? UnKnown
                self.timetitView.stringValue = rate.time ?? UnKnown
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.borderColor = NSColor.gridColor.cgColor
        
        
    }
    
}
