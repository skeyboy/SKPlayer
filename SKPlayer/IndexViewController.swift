//
//  IndexViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import AppKit
import Ji
class IndexItemModel{
    var linkPicUrl: String?
    var link: String?
    var title: String?
    
}
class Section {
    var title:String?
    var link: String?
    var sectionItems:[IndexItemModel] = [IndexItemModel]()
}
class IndexViewController: NSViewController {
    
    var indexs:[[IndexItemModel]] = [[IndexItemModel]]()
    var indexSections:[Section] = [Section]()
    @IBOutlet weak var indexCollection: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
//        let layout: NSCollectionViewGridLayout = NSCollectionViewGridLayout.init()
//        layout.maximumItemSize = NSSize(width: 300, height: 200)
//        layout.minimumItemSize = NSSize(width: 150, height: 100)
        
         let layout:NSCollectionViewFlowLayout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 300, height: 200)
        layout.estimatedItemSize = NSSize(width: 150, height: 100)
        layout.sectionHeadersPinToVisibleBounds = true


        self.indexCollection.collectionViewLayout = layout
        URLSession.shared.dataTask(with: URL.init(string: "http://www.btbtdy.net/")!) { (data, resp, error) in
           
            
            let ji =  Ji.init(data: data, isXML: false)
            
            var sections: [JiNode] =    (ji?.xPath("//div[@class='index_ui_2']/div[@class='cts']"))!
            
            for section in sections {
                var titleItems: [JiNode] = section.xPath("./div[@class='cts_a01']/ul[@class='cts_a01_1 hd']/li/text()")
                var itemsContents: [JiNode] = section.xPath("./div[@class='cts_a02 bd']")
                var index = 0
                for title in titleItems {
                    if index == itemsContents.count {
                        continue
                    }
                    var innerSection: Section = Section()
                    
                    innerSection.title = title.rawContent!
                    
                    let contentsItems = (itemsContents[index] as JiNode).xPath("./ul[@class='cts_list list_lis']/li")
                    for li in contentsItems {
                        
                        let indexItemModel: IndexItemModel = IndexItemModel()
                        var linkPicUrl =      li.xPath(".//a/img").first?.attributes["src"]
                        if linkPicUrl == nil {
                            linkPicUrl = li.xPath(".//a/img").first?.attributes["data-src"]
                        }
                        let link =  li.xPath("./div[@class='liimg']/a[@class='pic_link']").first?.attributes["href"]
                        let title =   li.xPath("./div[@class='liimg']/a[@class='pic_link']").first?.attributes["title"]
                        indexItemModel.linkPicUrl = linkPicUrl
                        indexItemModel.link = link
                        indexItemModel.title = title
                        innerSection.sectionItems.append(indexItemModel)
                    }
                    self.indexSections.append(innerSection)
                    
                    index = index + 1
                }
            }
            DispatchQueue.main.async {
                
            self.indexCollection.reloadData()
            }
        }.resume()
    }
    
}

extension IndexViewController: NSCollectionViewDelegate{
    
}
extension IndexViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.indexSections[section].sectionItems.count
    }
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return indexSections.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
       
        
        let item:IndexViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("IndexViewItem"), for: indexPath) as! IndexViewItem
         let indexModel: IndexItemModel = (self.indexSections[indexPath.section] as Section).sectionItems[indexPath.item]
        item.indexModel = indexModel
        return item
    }

    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        let view: IndexHeaderView = collectionView.makeSupplementaryView(ofKind: NSCollectionView.SupplementaryElementKind.sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IndexHeaderView"), for: indexPath) as! IndexHeaderView
        
        // 2
       view.indexSectionHeaderView.stringValue = self.indexSections[indexPath.section].title  ?? "未知"
        return view
    }
    
}
extension IndexViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return self.indexSections.count == 0 ? NSZeroSize : NSSize(width: 1000, height: 40)
    }
}
