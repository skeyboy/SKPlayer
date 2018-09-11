//
//  CloudPlayerController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class CloudPlayerController: NSViewController {
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
        
    }
    
}
