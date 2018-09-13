//
//  MenuViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Ji
let MainQueue = DispatchQueue.main
class Menu {
    var menuHref: String?
    var menuTitle: String?
    
}
class MenuViewController: NSViewController {
    var menuItems:[Menu] = [Menu]()
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
        self.parser(HOST_URL) { (ji, resp, error) in
            let menus:[JiNode] = (ji?.xPath("//div[@class='head02 lf']/ul/li/a"))!
            for node in menus {
                let menu: Menu = Menu()
                
                let title = node.xPath("./text()").first?.rawContent!
                let href = node.attributes["href"]
                
                menu.menuHref = href
                menu.menuTitle = title
                
                self.menuItems.append(menu)
            }
            MainQueue.async {
                self.menuCollection.reloadData()
                
            }
        }
    }
    
    
    
}
extension MenuViewController: Parser{}
extension MenuViewController: NSCollectionViewDelegate{
    
}
extension MenuViewController: NSCollectionViewDataSource{
    
    // 1
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return   self.menuItems.count
    }
    
    // 2
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item: MenuViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MenuViewItem"), for: indexPath) as! MenuViewItem
        let menu: Menu = self.menuItems[indexPath.section]
        
        item.titleView.stringValue = menu.menuTitle ?? "未知"
        
        item.isSelected = false
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        (item as! MenuViewItem).isSelected = false
    }
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
    }
    
}
