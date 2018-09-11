//
//  CloudPlayerController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import VLCKit
typealias CloudPlayerSelectedResult = (String?)->Void
class CloudPlayerController: NSViewController {
    var callBack: CloudPlayerSelectedResult?
    var session: NSApplication.ModalSession?
    @IBOutlet weak var resourceCollectionView: NSCollectionView!
    var cloudResources: [CloudPlayer] = [CloudPlayer]()
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
        return self.cloudResources.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cloudViewItem: CloudViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("CloudViewItem"), for: indexPath) as! CloudViewItem
        
        let cloudResource: CloudPlayer = self.cloudResources[indexPath.item]
        cloudViewItem.player = cloudResource
        return cloudViewItem
    }
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
      
        
        
        
        let indexPath = indexPaths.first!
        let cloudResource: CloudPlayer = self.cloudResources[indexPath.item]
      
        callBack!(cloudResource.link)
//        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.init("show_player"), sender: nil)
//        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.init("show_player")
//        , sender: cloudResource)
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
extension CloudPlayerController: VLCMediaDelegate{
    
}

extension CloudPlayerController: Parser{
   
}
