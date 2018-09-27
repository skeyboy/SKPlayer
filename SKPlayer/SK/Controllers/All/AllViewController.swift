//
//  AllViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/21.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Ji
let PageSection = 1
class AllViewController: NSViewController {
    
    
    var newHref: String?{
        didSet{
            MainQueue.async {
                
                self.skMenuView.viewDidload(href: HOST_URL +  self.newHref!)
            }
        }
    }
    
    @IBOutlet weak var skMenuView: SKMenuView!
    @IBOutlet weak var skMenuCollectionView: NSCollectionView!
    
    lazy var allItems:[IndexItemModel] = [IndexItemModel]()
     var page: Page?
    @IBOutlet weak var allCollectionView: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.skMenuView.allVC = self
        self.skMenuView.skMenuCollectionView = self.skMenuCollectionView

        let layout:NSCollectionViewFlowLayout = AllCollectionFlowLayout()
        layout.itemSize = IndexSectionSize
        layout.estimatedItemSize = IndexSectionSize
        layout.sectionHeadersPinToVisibleBounds = true
        
        layout.sectionHeadersPinToVisibleBounds = true
        self.allCollectionView.collectionViewLayout = layout
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    /// 用于从外部传递数据使用
    ///
    /// - Parameter nodes: nodes description
    func update( nodes:[JiNode]?, page: Page) -> Void {
        self.page = page
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
        
        MainQueue.async {
            self.allCollectionView.reloadData()
            if !self.allItems.isEmpty   {
            self.allCollectionView.scrollToItems(at: [IndexPath(item: 0, section: 0)], scrollPosition: NSCollectionView.ScrollPosition.top)
            }
            
        }
        
    }
}

extension AllViewController: NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("items select")
        collectionView.deselectItems(at: indexPaths)
        
        
        let indexPath = indexPaths.first!
        if indexPath.section == PageSection  {
            let pageItem: PageItem = self.page!.pages[indexPath.item]
            if let link = pageItem.link {
                self.newHref = link
            }
            return
        }
        
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
        if section == PageSection && self.page != nil {
            return self.page!.pages.count
        }
        return self.allItems.count
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        if self.page == nil {
            return 1
        }
        return 2
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        if indexPath.section == PageSection {
            
            
            let pageViewItem: AllPageViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("AllPageViewItem"), for: indexPath) as! AllPageViewItem
           
            let pageItem = self.page!.pages[indexPath.item] as PageItem
            pageViewItem.pageItem = pageItem
            
            
            return pageViewItem
        }
        
        let item:IndexViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("IndexViewItem"), for: indexPath) as! IndexViewItem
//        let indexModel: IndexItemModel = self.allItems[indexPath.item]
//        item.indexModel = indexModel
//        item.indexPath = indexPath
        
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath){
        if indexPath.section == PageSection {
            return
        }
        let aItem:IndexViewItem = item as! IndexViewItem
        let indexModel: IndexItemModel = self.allItems[indexPath.item]
        aItem.indexModel = indexModel
        aItem.indexPath = indexPath
    }

}

extension AllViewController : NSCollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize{
        
        
        if indexPath.section != PageSection {
            return CGSize(width: 216, height: 352)
        } else {
            return CGSize(width: 44, height: 44)
        }
    }
   
    
}
