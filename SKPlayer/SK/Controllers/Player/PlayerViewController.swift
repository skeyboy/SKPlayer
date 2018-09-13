//
//  PlayerViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import VLCKit
import WebKit
class PlayerViewController: NSViewController {
    var media: VLCMedia?
    var playerView: VLCVideoView = VLCVideoView()
    var mediaPlayer: VLCMediaPlayer?
    
    var movie:VLCMedia?
    
    @IBOutlet weak var webView: WebView!
    var player: VLCMediaPlayer?
    var resourceUrl: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if self.resourceUrl == nil {
            return
        }
        
        self.parser(HOST_URL+self.resourceUrl!) { (ji, resp, error) in
            
            let playerSource = ji?.xPath("//div[@class='p_movie']/iframe")?.first?.attributes["src"]
            self.createPlayer(playerSource!)
        }
    }
    
    func createPlayer(_ url:String) -> Void {
        let rURL: URL = URL.init(string: url)!
        NSWorkspace.shared.open(rURL)
        dismissViewController(self)
        return
            
            self.view.addSubview(self.playerView)
        self.playerView.frame = self.view.bounds
        self.playerView.autoresizingMask = [.width, .height]
        self.playerView.fillScreen = true
        
        self.mediaPlayer = VLCMediaPlayer(videoView: self.playerView)
        self.mediaPlayer?.delegate = self as! VLCMediaPlayerDelegate
        self.movie = VLCMedia(url: rURL)
        self.mediaPlayer?.media = self.movie
        self.mediaPlayer?.play()
    }
}

extension PlayerViewController: Parser, VLCMediaPlayerDelegate{}
