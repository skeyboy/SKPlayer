//
//  LatestViewItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/19.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import AppKit
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
            self.createShare()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
       
    }
    func createShare( ) -> Void {
        let menu = NSMenu(title: "保存")
        let shareItem = NSMenuItem(title: "分享",  action: #selector(share(sender:)), keyEquivalent: "")
        
        let shateItems = [
            NSAttributedString.init(string: self.todayItem!.title ?? ""),
            self.todayItem!.picLink!
            ] as [Any]
        let services = NSSharingService(named: NSSharingService.Name.cloudSharing)
        services?.perform(withItems: shateItems)
        services?.delegate = self
        shareItem.representedObject = services
        menu.addItem(shareItem)
        menu.addItem(withTitle: "收藏", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "保存图片", action: #selector(save(sender:)), keyEquivalent: "")
        self.view.menu = menu
    }
    @objc func share( sender: NSMenuItem) ->Void{
        // Items to share
        let shateItems = [
            NSAttributedString.init(string: self.todayItem!.title ?? ""),
            self.todayItem!.picLink!
            ] as [Any]
        (sender.representedObject as! NSSharingService).perform(withItems: shateItems)
//         NSSharingServicePicker(items: shateItems).show(relativeTo: self.view.visibleRect, of: self.view, preferredEdge: NSRectEdge.minX)
    }
    @objc func save( sender: NSMenuItem) -> Void{
        let panel: NSSavePanel = NSSavePanel()
        panel.message = "选择图片保存地址"
        panel.nameFieldStringValue = "\(self.todayItem!.picLink!.hashValue)"
        panel.allowedFileTypes = ["jpg", "png","jpeg"]
        panel.canCreateDirectories = true
        
        [panel .begin(completionHandler: { resp in
            if resp == NSApplication.ModalResponse.OK {
                let data = self.picView.image?.tiffRepresentation
                if let data = data {
                   try! data.write(to: panel.url!, options: Data.WritingOptions.atomicWrite)
                }
            }
        })]
        
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        self.descView.alphaValue = 0.8
    }
    
}

extension LatestViewItem: NSSharingServiceDelegate{
    func sharingService(_ sharingService: NSSharingService, sourceWindowForShareItems items: [Any], sharingContentScope: UnsafeMutablePointer<NSSharingService.SharingContentScope>) -> NSWindow? {
        return self.view.window
    }
     public func sharingService(_ sharingService: NSSharingService, sourceFrameOnScreenForShareItem item: Any) -> NSRect{
        return self.view.visibleRect
    }
    
}
