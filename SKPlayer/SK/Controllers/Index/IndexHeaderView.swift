//
//  IndexHeaderView.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import SnapKit
typealias HeaderCallBack = (Int, IndexPath)->Void
class IndexHeaderView: NSView {
    var indexPath: IndexPath?
    var currentIndex: Int = 0
    var subItemsUI:[NSButton] = [NSButton]()
    var headerCallBack:HeaderCallBack?
    @objc func sectionHeaderSelcted(sender: NSButton){
        sender.state = NSControl.StateValue.on
        sender.highlight(true)

       if let headerCallBack = self.headerCallBack {
            MainQueue.async {            
                headerCallBack(sender.tag, self.indexPath!)
            }
        }
        
    }
    var sectionTitles:[String]?{
        didSet{
            var index = 0
            var tmpBtn: NSButton?
            for title in self.sectionTitles ?? [String]() {
                let btn:NSButton = NSButton(title: title, target: self, action: #selector(sectionHeaderSelcted(sender:)))

                btn.frame = CGRect.zero
                btn.highlight(self.currentIndex == index)
                if self.currentIndex == index {
                    btn.state = NSControl.StateValue.on
                }else{
                    btn.state = NSControl.StateValue.off
                }
                self.addSubview(btn)
                btn.title = title
                self.addSubview(btn)
                btn.snp.makeConstraints { (maker) in
                    maker.centerY.equalTo(self.snp.centerY)
                    maker.width.equalTo(100)
                    maker.height.lessThanOrEqualToSuperview()
                    if index == 0 {
                        maker.left.equalTo(self.snp.left).offset(10)
                    }else{
                        maker.left.equalTo(tmpBtn!.snp.right).offset(10)

                    }
                    if index == self.sectionTitles!.count - 1 {
                        
                    }
                    
                }
                btn.tag = index
                tmpBtn = btn
                index += 1
            }
            
        }
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor(calibratedWhite: 0.8 , alpha: 0.8).set()
     }
    @IBOutlet weak var indexSectionHeaderView: NSTextField!
    
}

