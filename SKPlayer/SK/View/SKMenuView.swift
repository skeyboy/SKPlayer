//
//  SKMenuView.swift
//  SKPlayer
//
//  Created by sk on 2018/9/20.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Ji

class SKMenu {
    var kind: String
    lazy var subMenus: [SKMenuItem] = [SKMenuItem]()
    init(kind: String = "选择类型") {
        self.kind = kind
    }
}
class SKMenuItem{
    var on: Bool = false
    var title: String
    var link: String
    init(on: Bool, title: String, link: String) {
        self.on = on
        self.title  = title
        self.link = link
    }
    convenience init(title: String, link: String){
        self.init(on: false, title: title, link: link)
    }
    
}

class SKMenuView: NSView {
    weak var allVC: AllViewController?
    weak  var skMenuCollectionView: NSCollectionView?{
        didSet{
            self.skMenuCollectionView?.delegate = self
            self.skMenuCollectionView?.dataSource = self
            //            self.viewDidload()
        }
    }
    var skMenus:[SKMenu] = [SKMenu]()
    lazy var lock: NSRecursiveLock = NSRecursiveLock()
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func update() -> Void {
        
        self.skMenuCollectionView?.reloadData()
        return
        let group = DispatchGroup.init()
        let queue =  DispatchQueue.init(label: "Latest", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: MainQueue)
        for i in 0 ... self.skMenus.count - 1 {
            
            queue.async(group: group, qos: DispatchQoS.background, flags: DispatchWorkItemFlags.barrier, execute: {
                MainQueue.async {
                    
                    let section = IndexSet(integer: i)
                    self.skMenuCollectionView?.insertSections(section)
                }
            })
            
        }
    }
    func viewDidload( href: String = "http://www.btbtdy.net/btfl/dy1.html" ) -> Void {
        
        self.updateMenu(href) { (ts) in
            if !self.skMenus.isEmpty {
                self.skMenus.removeAll()
            }
            self.skMenus.append(contentsOf: ts)
            self.update()
        }
    }
}




extension SKMenuView : Parser{
    func updateMenu(_ menuURL: String, result:@escaping ([SKMenu])->Void){
        var skMenus: [SKMenu] = [SKMenu]()
        self.showProgressHUD(title: "努力加载", message: "loading", mode: ProgressHUDMode.determinate)
        parser(menuURL) { (ji, resp, error) in
            self.hideProgressHUD()
            
            if let allVC =  self.allVC {
                MainQueue.async {
                    
                    allVC.update(nodes:ji?.xPath("//div[@class='list_su']/ul/li"))
                }
            }
            let  items: [JiNode]? = ji?.xPath("//div[@class='s_index']/dl")
            
            if let items = items {
                
                self.lock.lock()
                items.forEach({ (node) in
                    
                    let title = node.firstChild?.xPath("./text()").first!.rawContent ?? UnKnown
                    let skMenu:SKMenu = SKMenu(kind: title)
                    
                    let subs = node.xPath("./dd/a")
                    
                    subs.forEach({ (subNode) in
                        let href = subNode.attributes["href"]!
                        let subTitle = subNode.xPath("./text()").first!.rawContent!
                        let on: Bool = subNode.attributes["class"] == "current"
                        let subMenu: SKMenuItem = SKMenuItem(on: on, title: subTitle, link: href)
                        
                        skMenu.subMenus.append(subMenu)
                    })
                    skMenus.append(skMenu)
                })
                result(skMenus)
                self.lock.unlock()
            }
        }
    }
    
}
extension SKMenuView: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.skMenus[section].subMenus.count
    }
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return self.skMenus.count
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let itemView: SKMenuViewitem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("SKMenuViewitem"), for: indexPath) as! SKMenuViewitem
        
        let menuItem: SKMenuItem = self.skMenus[indexPath.section].subMenus[indexPath.item]
        
        itemView.item = menuItem
        return itemView
    }
    
    
}
extension SKMenuView: NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let header: SKMenuHeaderView =  collectionView.makeSupplementaryView(ofKind: NSCollectionView.SupplementaryElementKind.sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier.init("SKMenuHeaderView"), for: indexPath) as! SKMenuHeaderView
        header.titleView.stringValue = self.skMenus[indexPath.section].kind
        return header
    }
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let indexPath: IndexPath = indexPaths.first!
        let menuItem: SKMenuItem = self.skMenus[indexPath.section].subMenus[indexPath.item]
        
        self.updateMenu(HOST_URL + menuItem.link) { (ts) in
            
            MainQueue.async {
                self.skMenus.removeAll()
                self.skMenus.append(contentsOf: ts)
                self.skMenuCollectionView?.reloadData()
                //                self.skMenuCollectionView?.reloadSections(IndexSet(integer: indexPaths.first!.section))
                //
                //                self.skMenuCollectionView?.reloadSections(IndexSet(integer: self.skMenus.count))
                
            }
        }
        
    }
}

extension SKMenuView: NSCollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 88, height: 24)
    }
}
