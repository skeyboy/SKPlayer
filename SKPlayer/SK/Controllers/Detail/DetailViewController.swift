//
//  DetailViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Kingfisher
let UnKnown = "未知"

/// 0 titie 1 query
typealias DetailDoor = (String?, String)
class DetailViewController: NSViewController {
    let parser:DetailParser = DetailParser()
    @IBOutlet weak var yearView: NSTextField!
    @IBOutlet weak var titleView: NSTextField!
    @IBOutlet weak var coverImageView: NSImageView!
    @IBOutlet weak var stateView: NSTextField!
    @IBOutlet weak var kindView: NSTextField!
    @IBOutlet weak var langView: NSTextField!
    
    @IBOutlet weak var imbdView: NSTextField!
    @IBOutlet weak var mainsView: NSTextField!
    @IBOutlet weak var desView: NSTextField!
    @IBOutlet weak var updateView: NSTextField!
    
    /// 0 titie 1 query
    var detailDoor: DetailDoor? {
        didSet{
        }
    }
    func fetchDetailInfo() -> Void {
        if (self.view.window != nil) {
            
            self.view.window?.title = self.detailDoor!.0 ?? "详情"
        }
        self.parser.detailParser((self.detailDoor?.1)!) { (detail) in
            DispatchQueue.main.async {
                self.coverImageView.kf.setImage(with: URL.init(string: detail.coverSrc!)!)
                do{
                    self.titleView.stringValue = detail.title ?? UnKnown
                    self.yearView.stringValue =   detail.year ?? UnKnown
                    self.updateView.stringValue = "更新:" +  detail.update!
                    self.stateView.stringValue = "状态:" + detail.state!
                    self.kindView.stringValue = "类型:" + detail.kind!
                    self.langView.stringValue = "语言:" +  ( detail.lang ?? UnKnown)
                    self.imbdView.stringValue = "imbd:" + detail.imdb!
                    self.mainsView.stringValue = "主演:" +  detail.mains!
                    self.desView.stringValue = "简介:" + detail.des!
                    
                }catch{
                    print("unwrap出错")
                }
                if  detail.isNotEmpty  {
                    self.createCloudResourceWin(resources: detail.resources)
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
        self.fetchDetailInfo()
        
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let player: PlayerViewController = segue.destinationController as! PlayerViewController
        player.resourceUrl =  (sender as! String)
    }
}

extension DetailViewController{
    
    /// 根据获取的播放资源加载底部的资源列表
    ///
    /// - Parameter resources: 包含网页播放地址  bt资源地址
    func createCloudResourceWin(resources:Resuorces){
        let cloudPlayerVC: CloudPlayerController =   self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("cloud")) as! CloudPlayerController
        cloudPlayerVC.resources = resources
        cloudPlayerVC.prepareCallBack = {cloudPlayer in
            
            
            
            self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.init("show_player"), sender: cloudPlayer?.link)
        }
        
        let win: NSWindow = NSWindow.init(contentViewController: cloudPlayerVC)
        win.styleMask = [.miniaturizable, .closable]
        if self.view.window != nil {
            NSAnimationContext.runAnimationGroup({ (ctx) in
                let frame: CGRect = self.view.window!.frame
                let winFrame: CGRect = cloudPlayerVC.view.frame
                let winX = frame.origin.x
                let winY =  frame.origin.y - winFrame.size.height - 3
                
                let newWinFrame = NSRect(x:winX , y: winY, width: frame.size.width, height: winFrame.size.height)
                win.animator().setFrame(newWinFrame, display: true)
                self.view.window?.animator().addChildWindow(win, ordered: NSWindow.OrderingMode.below)
            }) {
                
            }
           
        }
    }
    
}
