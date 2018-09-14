//
//  CloudPlayerController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import VLCKit
typealias CloudPlayerSelectedResult = (CloudPlayer?)->Void
class CloudPlayerController: NSViewController {
    var prepareCallBack: CloudPlayerSelectedResult?
    var session: NSApplication.ModalSession?
    @IBOutlet weak var resourceCollectionView: NSCollectionView!
    var resources: Resuorces?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.resourceCollectionView.reloadData()
    }
    
}
extension CloudPlayerController: NSCollectionViewDelegate{
    
}
extension CloudPlayerController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return (self.resources?.cloudPlayer.count)!
        }
        if section == 1 {
            return (self.resources?.cloudDown.count)!
        }
        return 0
    }
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        
        return 2
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if indexPath.section == 0 {
            
            let cloudViewItem: CloudViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init( "CloudViewItem"), for: indexPath) as! CloudViewItem
            
            var items: [CloudPlayer] = [CloudPlayer]()
            if indexPath.section == 0 {
                items = (self.resources?.cloudPlayer)!
            }
            if indexPath.section == 1 {
                items = (self.resources?.cloudDown)!
            }
            
            cloudViewItem.player = items[indexPath.item]
            return cloudViewItem
        }else{
            
            
            let cloudViewItem: CloudViewBTItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init( "CloudViewBTItem"), for: indexPath) as! CloudViewBTItem
            
            var items: [CloudPlayer] = [CloudPlayer]()
            if indexPath.section == 0 {
                items = (self.resources?.cloudPlayer)!
            }
            if indexPath.section == 1 {
                items = (self.resources?.cloudDown)!
            }
            
            cloudViewItem.player = items[indexPath.item]
            return cloudViewItem
            
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        collectionView.deselectItems(at: indexPaths)
        let indexPath = indexPaths.first!
        var items: [CloudPlayer] = [CloudPlayer]()
        if indexPath.section == 0 {
            items = (self.resources?.cloudPlayer)!
        }
        if indexPath.section == 1 {
            items = (self.resources?.cloudDown)!
        }
        
        let cloudResource: CloudPlayer = items[indexPath.item]
        
        if indexPath.section == 0 {
            self.prepareCallBack!(cloudResource)
        }else{
            open(resource: cloudResource)
        }
        
    }
    
}
extension CloudPlayerController: NSViewControllerPresentationAnimator{
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        
        let containerView = fromViewController.view
        
        let finalFrame = NSInsetRect(containerView.bounds, 50, 50)
        let modalView = viewController.view
        
        modalView.frame = finalFrame
        modalView.setFrameOrigin(NSMakePoint(finalFrame.origin.x, finalFrame.origin.y - 200))
        
        containerView.addSubview(modalView)
        
        NSAnimationContext.runAnimationGroup({ (animationContext) in
            animationContext.duration = 0.5
            modalView.animator().frame = finalFrame
            
        }, completionHandler: nil)
        
        
    }
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        let startFrame = viewController.view.frame
        NSAnimationContext.runAnimationGroup({ (animationContext) in
            animationContext.duration = 0.5
            viewController.view.animator().setFrameOrigin(NSMakePoint(startFrame.origin.x, startFrame.origin.y - fromViewController.view.bounds.size.height - 100))
        }) {
            viewController.view.removeFromSuperview()
        }
    }
    
    
}
extension CloudPlayerController: NSCollectionViewDelegateFlowLayout{
    @available(OSX 10.11, *)
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize{
        if indexPath.section == 0 {
            return CGSize(width: 80, height: 50)
        }
        return CGSize(width: self.view.bounds.size.width/2, height: 50)
    }
}


// MARK: - 打开资源
extension CloudPlayerController{
    
    
    func open(bts BTs:[BT]) -> Void {
        let btWinVC: NSWindowController =   self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("BT_WIN")) as! NSWindowController
        
        let session =   NSApp.beginModalSession(for: btWinVC.window!)
        let btVC: BTViewController =    btWinVC.contentViewController as! BTViewController
        
        btVC.bts = BTs
        btVC.session = session
        
        while NSApp.runModalSession(session) == NSApplication.ModalResponse.continue {
            print("\(session)")
        }
    }
    func open(resource cloudPlayer:CloudPlayer) -> Void {
        if cloudPlayer is CloudDown {
            (cloudPlayer as! CloudDown).open(success: { (bts) in
                
                self.open(bts: bts)
            })
            
        }else{
            assert(cloudPlayer is CloudDown, "\(type(of: cloudPlayer))")
        }
        
    }
}
