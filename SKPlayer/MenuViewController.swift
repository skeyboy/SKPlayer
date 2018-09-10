//
//  MenuViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class MenuViewController: NSViewController {
    let menuItems:[String] = [String]()
    @IBOutlet weak var menuCollection: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.menuCollection.delegate = self
        self.menuCollection.dataSource = self
        
        self.menuCollection.register(NSNib.init(nibNamed: NSNib.Name.init("MenuViewItem"), bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier.init("menu_item"))
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 100, height: 55)
        flowLayout.sectionInset = NSEdgeInsets(top: 0.0, left: 0, bottom: 0.0, right: 0.0)
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.minimumLineSpacing = 2.0
        self.menuCollection.collectionViewLayout = flowLayout
        self.menuCollection.reloadData()
        self.menuCollection.backgroundColors = [NSColor.gray]
    }
    

    
}
extension MenuViewController: NSCollectionViewDelegate{
 
}
extension MenuViewController: NSCollectionViewDataSource{
   
    // 1
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 11
    }
    
    // 2
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
    
    // 3
   
        // 4
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MenuViewItem"), for: indexPath)
        guard let collectionViewItem = item as? MenuViewItem else {return item}
        
      item.isSelected = false
        return item
    }
    
    
}
