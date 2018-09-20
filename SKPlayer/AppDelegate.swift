//
//  AppDelegate.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import VLCKit
let HOST_URL = "http://www.btbtdy.net"
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            NSApp.windows.first?.makeKeyAndOrderFront(self)
            return true
        }
        return false
    }
}

