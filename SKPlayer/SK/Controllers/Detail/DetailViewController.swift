//
//  DetailViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Kingfisher
class DetailViewController: NSViewController {
    let parser:DetailParser = DetailParser()
    var session: NSApplication.ModalSession?
    @IBOutlet weak var yearView: NSTextField!
    @IBOutlet weak var titleView: NSTextField!
    @IBOutlet weak var coverImageView: NSImageView!
    
    @IBOutlet weak var desView: NSTextField!
    @IBOutlet weak var updateView: NSTextField!
    var model: IndexItemModel?{
        didSet{
            self.view.window?.title = model?.title ?? "详情"
            self.parser.detailParser((model?.link!)!) { (detail) in
                DispatchQueue.main.async {
                
                self.coverImageView.kf.setImage(with: URL.init(string: detail.coverSrc!)!)
                self.titleView.stringValue = detail.title!
                self.yearView.stringValue = detail.year!
                self.desView.stringValue = detail.des!
                if detail.resources.cloudPlayer.count > 0 {
                    self.createCloudResourceWin(resources: detail.resources)
                }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    override func viewDidAppear() {
        super.viewDidAppear()
       
    }
    internal func createCloudResourceWin(resources:Resuorces){
        let cloudPlayerVC: CloudPlayerController =   self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("cloud")) as! CloudPlayerController
        cloudPlayerVC.resources = resources
        cloudPlayerVC.callBack = {cloudPlayer in
            if self.session != nil {
                NSApp.modalWindow?.close()
                self.session = nil
            }
            
            if cloudPlayer! is CloudDown {
                (cloudPlayer as! CloudDown).open()
                return
            }
            self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.init("show_player"), sender: cloudPlayer?.link)
return
            let playerWinVC:PlayerWindowController =    self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "player_window")) as! PlayerWindowController
            (playerWinVC.contentViewController as! PlayerViewController).resourceUrl = cloudPlayer?.link
            
      self.session =       NSApp.beginModalSession(for: playerWinVC.window!)
        }
        let win: NSWindow = NSWindow.init(contentViewController: cloudPlayerVC)
        win.styleMask = [.miniaturizable, .closable]
        
        
        let frame: CGRect = self.view.window!.frame
        let winFrame: CGRect = cloudPlayerVC.view.frame
        let winX = frame.origin.x
        let winY =  frame.origin.y - winFrame.size.height - 5
        
        let newWinFrame = NSRect(x:winX , y: winY, width: frame.size.width, height: winFrame.size.height)
        win.setFrame(newWinFrame, display: true)
        self.view.window?.addChildWindow(win, ordered: NSWindow.OrderingMode.below)
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
//                let playerWinVC: PlayerWindowController =  segue.destinationController as! PlayerWindowController
                let player: PlayerViewController = segue.destinationController as! PlayerViewController
        player.resourceUrl =  (sender as! String)
    }
}
