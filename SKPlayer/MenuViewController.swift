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

enum Type: Int{
    case indexView = 0
    case latestView = 1
    case allView = 2
    case rate = 3
    case new = 4
    case unknown
}
class MenuViewController: NSViewController {
    weak var contentVC: ContainerController?
    var menuItems:[Menu] = [Menu]()
    @IBOutlet weak var menuCollection: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.menuCollection.isSelectable = true
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
            self.menuItems.removeSubrange(Range(NSRange(location: 9, length: 5))!)
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
        item.indexPath = indexPath
        let menu: Menu = self.menuItems[indexPath.section]
        
        item.titleView.stringValue = menu.menuTitle ?? "未知"
        item.hoverBack = {(index) in
            MainQueue.async {
//                self.selected(item: index!)
            }
        }
        item.isSelected = false
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        (item as! MenuViewItem).isSelected = false
    }
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        collectionView.deselectItems(at: indexPaths)
        selected(item: indexPaths.first!)
    }
    
    func selected(item indexPath: IndexPath) -> Void {
        if let containerVC = self.contentVC {
            var type: Type = Type.indexView
            
            switch indexPath.section {
                
            case 0: type = .indexView
                break
            case 1 ... 5:
                type = .allView
                break
            case 8:
                type = .latestView
                break
            case 6 :
                type = .new
                break
            case 7 :
                type = .rate
                break
            default:
                type = .unknown
            }
            
            
            if type != Type.unknown {
                
                let menuHO: Menu =    self.menuItems[indexPath.section]
                
                containerVC.change(type: type, href: menuHO.menuHref!)
                
            }
        }
    }
}
