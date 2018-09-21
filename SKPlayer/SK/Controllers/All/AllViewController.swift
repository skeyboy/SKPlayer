//
//  AllViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/21.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Ji
class AllViewController: NSViewController {
    
    
    var newHref: String?{
        didSet{
            
            self.skMenuView.viewDidload(href: HOST_URL +  self.newHref!)
        }
    }
    
    @IBOutlet weak var skMenuView: SKMenuView!
    @IBOutlet weak var skMenuCollectionView: NSCollectionView!
    
    lazy var allItems:[IndexItemModel] = [IndexItemModel]()
    
    @IBOutlet weak var allCollectionView: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.skMenuView.allVC = self
        self.skMenuView.skMenuCollectionView = self.skMenuCollectionView

        let layout:NSCollectionViewFlowLayout = NSCollectionViewFlowLayout()
        layout.itemSize = IndexSectionSize
        layout.estimatedItemSize = IndexSectionSize
        layout.sectionHeadersPinToVisibleBounds = true
        
        layout.sectionHeadersPinToVisibleBounds = true
        self.allCollectionView.collectionViewLayout = layout
        
    }
    
    
    /// 用于从外部传递数据使用
    ///
    /// - Parameter nodes: nodes description
    func update( nodes:[JiNode]?) -> Void {
        if !self.allItems.isEmpty {
            self.allItems.removeAll()
        }
        for lisItem in nodes! {
            let indexItemModel: IndexItemModel = IndexItemModel()
            var linkPicUrl =      lisItem.xPath(".//*/img").first?.attributes["src"]
            if linkPicUrl == nil {
                linkPicUrl = lisItem.xPath(".//*/img").first?.attributes["data-original"]
            }
            if linkPicUrl == nil {
                linkPicUrl = lisItem.xPath(".//img").first?.attributes["data-src"]
            }
            let link =  lisItem.xPath("./div[@class='liimg']/a[@class='pic_link']").first?.attributes["href"]
            let title =   lisItem.xPath("./div[@class='liimg']/a[@class='pic_link']").first?.attributes["title"]
            
            let score = lisItem.xPath("./div[@class='cts_ms']/p[@class='title']/span[1]/text()").first?.rawContent ?? UnKnown
            
            let des = lisItem.xPath("./div[@class='cts_ms']/p[@class='des']/text()").first?.rawContent ?? UnKnown
            
            indexItemModel.linkPicUrl = linkPicUrl
            indexItemModel.link = link
            indexItemModel.title = title
            indexItemModel.des = des
            indexItemModel.score = score
            self.allItems.append(indexItemModel)
        }
        self.allCollectionView.reloadData()
    }
}

extension AllViewController: NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("items select")
        collectionView.deselectItems(at: indexPaths)
        
        
        let indexPath = indexPaths.first!
       
        
        let detailWin: DetailWindowController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("detail_window")) as! DetailWindowController
        let detailVC: DetailViewController = detailWin.contentViewController as! DetailViewController
        
        
        detailVC.detailDoor = (self.allItems[indexPath.item].title,self.allItems[indexPath.item].link ) as? DetailDoor
        let session = NSApp.beginModalSession(for: detailWin.window!)
        
        while NSApp.runModalSession(session) == NSApplication.ModalResponse.continue {
            print("...")
            
            NSApp.endModalSession(session)
        }
        
    }
    
}
extension AllViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allItems.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item:IndexViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("IndexViewItem"), for: indexPath) as! IndexViewItem
        let indexModel: IndexItemModel = self.allItems[indexPath.item]
        item.indexModel = indexModel
        item.indexPath = indexPath
        
        return item
    }
    
    
}

