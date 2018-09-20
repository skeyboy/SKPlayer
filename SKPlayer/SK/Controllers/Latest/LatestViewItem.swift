//
//  LatestViewItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/19.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Kingfisher
class LatestViewItem: NSCollectionViewItem {
    @IBOutlet weak var picView: NSImageView!
    @IBOutlet weak var descView: NSTextField!
    @IBOutlet weak var titleView: NSTextField!
    @IBOutlet weak var scoreView: NSTextField!
    @IBOutlet weak var infoView: NSTextField!
    @IBOutlet weak var rtView: NSTextField!
    var todayItem: TodayItem? {
        didSet{
            if let url = URL.init(string: self.todayItem!.picLink!){
                
                self.picView.kf.setImage(with: url)
            }
            self.titleView.stringValue = self.todayItem!.title ?? UnKnown
            self.descView.stringValue = self.todayItem!.totalDesc ?? UnKnown
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let menu = NSMenu(title: "保存")
        menu.addItem(withTitle: "查看", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "收藏", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "保存图片", action: #selector(save(sender:)), keyEquivalent: "")
                self.view.menu = menu
    }
    @objc func save( sender: NSMenuItem) -> Void{
        let panel: NSOpenPanel = NSOpenPanel()
        panel.canCreateDirectories = true
        panel.canChooseDirectories = true
        [panel .begin(completionHandler: { resp in
            if resp == NSApplication.ModalResponse.OK {
                print(panel.url)
            }
        })]
        
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        self.descView.alphaValue = 0.8
    }
    
}
