//
//  MenuViewItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
typealias HoverBack = (IndexPath?)->Void

class MenuViewItem: NSCollectionViewItem {
    var indexPath: IndexPath?
    var hoverBack: HoverBack?
    @IBOutlet weak var titleView: NSTextField!
    override var isSelected: Bool{
        didSet{
            (self.view as! HoverView).isSelected = self.isSelected
            (self.view as! HoverView).hoverSelectedResponse = {(hover , isHoverd) in
                if isHoverd {
                    if let hoverBack = self.hoverBack {
                            hoverBack(self.indexPath)
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        titleView.stringValue = "\(arc4random())"
    }
 
}
