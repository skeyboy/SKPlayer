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
import CoreGraphics
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
            self.scoreView.stringValue = self.todayItem!.score
            self.infoView.stringValue = self.todayItem!.info ?? UnKnown
            self.rtView.stringValue = self.todayItem!.rt ?? UnKnown
            self.createShare()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.view.wantsLayer = true
        self.view.layer?.borderColor = NSColor.gridColor.cgColor
        if self.view is HoverView {
            
            (self.view as! HoverView).hoverSelectedResponse = {(hView, hovered) in
                self.view.layer?.borderWidth = hovered ? 0 : 2
                let dXY = hovered ? -7 : 7
                self.view.frame = NSInsetRect(self.view.frame, CGFloat(dXY), CGFloat(dXY))
            }
        }
        
    }
    func createShare( ) -> Void {
        let menu = NSMenu(title: "保存")
        
        let shateItems = [
            NSAttributedString.init(string: self.todayItem!.title ?? ""),
            self.todayItem!.picLink!, self.todayItem!.totalDesc ?? UnKnown
            ] as [Any]
        var allServices: [NSSharingService] = [NSSharingService]()
        let services = NSSharingService.sharingServices(forItems: shateItems)
        allServices.append(contentsOf: services)
        allServices.append(contentsOf:  [NSSharingService.Name.sendViaAirDrop,. addToIPhoto,.useAsDesktopPicture,.addToSafariReadingList, .addToAperture, .cloudSharing].map { (item) -> NSSharingService in
            return NSSharingService(named: item)!
        })
        for  service: NSSharingService in allServices {
            let shareItem: NSMenuItem = NSMenuItem(title: service.title,  action: #selector(share(sender:)), keyEquivalent: "")
            service.delegate = self
            shareItem.target = self
            shareItem.image = service.image
            shareItem.representedObject = service
            menu.addItem(shareItem)
        }
        
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
                let data = self.picView!.image!.tiffRepresentation
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

extension NSView {
    var screen: NSImage {
        
        let screenRect = self.bounds
        let screenSize = screenRect.size
        self.lockFocus()
        let offScreenRep =         self.bitmapImageRepForCachingDisplay(in: self.frame)
        self.cacheDisplay(in: self.frame, to: offScreenRep!)
        self.unlockFocus()
        let img: NSImage = NSImage(size: screenSize)
        img.addRepresentation(offScreenRep!)
        
        return img
        
    }
}
