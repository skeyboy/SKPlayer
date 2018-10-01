//
//  AppDelegate.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
 import Kingfisher
let HOST_URL = "http://www.btbtdy.net"
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
//        SKMenuView.init(frame: NSRect.zero).updateMenu()
        
        
        
        KingfisherManager.shared.cache.maxMemoryCost = 1024 * 1024 * 10
    }
//    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
//        var menu: NSMenu = NSMenu(title: "")
//
//        menu.addItem(withTitle: "历史", action: nil, keyEquivalent: "")
//        return nil
//    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
//        if flag {
            NSApp.windows.first?.makeKeyAndOrderFront(self)
            return true
//        }
        return false
    }
}

extension Int{
    var indexSet: IndexSet{
        return IndexSet(integer: self)
    }
}

extension Array{
    var indexSet: IndexSet {
        return IndexSet(integer: self.count)
    }
    func indexSets(from index: Int) -> IndexSet {
      return  IndexSet(integersIn: Range(NSRange(location: index, length: index <= self.count-1 ? self.count - index : 0 ))!)
    }
    func indexSets(from index: Int,  to:Int) -> IndexSet {
        if index > to {
            assert(false, "from 必须 小于 to")
        }
        let finallyTo  =  ( to <= self.count - 1 ? to : self.count - 1 )
        
        return IndexSet(integersIn: Range(NSRange(location: index, length:  finallyTo - index ))!)
    }
}
