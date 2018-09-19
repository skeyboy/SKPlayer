//
//  MenuViewItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class MenuViewItem: NSCollectionViewItem {
    @IBOutlet weak var titleView: NSTextField!
    override var isSelected: Bool{
        didSet{
            (self.view as! HoverView).isSelected = self.isSelected
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        titleView.stringValue = "\(arc4random())"
    }
 
}
