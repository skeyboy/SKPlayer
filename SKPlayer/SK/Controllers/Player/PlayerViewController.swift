//
//  PlayerViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import WebKit
class PlayerViewController: NSViewController {
    private var playURI: String = ""
    private var modal: NSApplication.ModalResponse = NSApplication.ModalResponse.cancel
    @IBOutlet weak var webView: WebView!
    var resourceUrl: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden  = true
        self.view.window?.styleMask = [.fullSizeContentView,.borderless]
        // Do view setup here.
        if self.resourceUrl == nil {
            return
        }
        self.parser(HOST_URL+self.resourceUrl!) { (ji, resp, error) in
            
            let playerSource = ji?.xPath("//div[@class='p_movie']/iframe")?.first?.attributes["src"]
            self.createPlayer(playerSource!)
        }
    }
    
    @objc func innerPlay(sender: NSButton){
        NSApp.stopModal(withCode: modal)
        let rURL: URL = URL.init(string: self.playURI)!
        let request = URLRequest.init(url: rURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        self.view.isHidden = false
        self.webView.mainFrame.load(request)
        self.view.window?.setFrame(NSRect(x: 200, y: 200, width: 1024, height: 768), display: true, animate: true)
        self.view.window?.center()
    }
    @objc func chromePlay(sender: NSButton){
        NSApp.stopModal(withCode: modal)
        dismiss(sender)
        
        let rURL: URL = URL.init(string: self.playURI)!
        NSWorkspace.shared.open(rURL)
    }
    @objc func cancelPlay(sender: NSButton){
        NSApp.stopModal(withCode: modal)
        dismiss(sender)
    }
    override func dismiss(_ sender: Any?) {
        self.view.window?.close()
        super.dismiss(sender)
        self.view.window?.close()
    }
    func createPlayer(_ url:String) -> Void {
        
        self.playURI = url
        
        let alert: NSAlert = NSAlert.init()
        alert.messageText = "选择播放方式"
//        alert.addButton(withTitle: "内部播放")
        alert.addButton(withTitle: "浏览器播放")
        alert.addButton(withTitle: "取消")
        
        alert.buttons.first!.action = #selector(chromePlay(sender:))
        alert.buttons.first?.target = self
        
//        alert.buttons[1].action = #selector(chromePlay(sender:))
//        alert.buttons[1].target = self
        
        alert.buttons.last?.action = #selector(cancelPlay(sender:))
        alert.buttons.last?.target = self
        
        modal =  alert.runModal()
        
    }
}

extension PlayerViewController: Parser{
}

