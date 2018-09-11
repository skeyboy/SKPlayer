//
//  DetailWindow.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class DetailWindow: NSWindow {
    var modalSession: NSApplication.ModalSession?
    override func close() {
        if let session = modalSession {
            NSApp.endModalSession(session)
        }
        title = "详情"
        super.close()
    }
}
