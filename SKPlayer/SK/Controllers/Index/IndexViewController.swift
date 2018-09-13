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

class IndexViewController: NSViewController {
    var session: NSApplication.ModalSession?
    var indexs:[[IndexItemModel]] = [[IndexItemModel]]()
    var indexSections:[Section] = [Section]()
    @IBOutlet weak var indexCollection: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        //        let layout: NSCollectionViewGridLayout = NSCollectionViewGridLayout.init()
        //        layout.maximumItemSize = NSSize(width: 300, height: 200)
        //        layout.minimumItemSize = NSSize(width: 150, height: 100)
        //
        let layout:NSCollectionViewFlowLayout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 100, height: 200)
        layout.estimatedItemSize = NSSize(width: 100, height: 200)
        layout.sectionHeadersPinToVisibleBounds = true
        
        layout.sectionHeadersPinToVisibleBounds = true
        self.indexCollection.collectionViewLayout = layout
        
        
        indexParser("http://www.btbtdy.net/") { (results) in
            
            self.indexSections.insert(contentsOf: results, at: 0)
            self.indexCollection.reloadData()
        }
    }
    
}

extension IndexViewController: NSCollectionViewDelegate{}
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
        item.indexPath = indexPath
        
        return item
    }
    
    private func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        let view: IndexHeaderView = collectionView.makeSupplementaryView(ofKind: NSCollectionView.SupplementaryElementKind.sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IndexHeaderView"), for: indexPath) as! IndexHeaderView
        view.indexSectionHeaderView.stringValue = self.indexSections[indexPath.section].title  ?? "未知"
        return view
    }
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("items select")
        
        
        let indexPath = indexPaths.first!
        let section: Section = self.indexSections[indexPath.section]
        
        let detailWin: DetailWindowController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("detail_window")) as! DetailWindowController
        let detailVC: DetailViewController = detailWin.contentViewController as! DetailViewController
        
        
        detailVC.model = section.sectionItems[indexPath.item]
        let session = NSApp.beginModalSession(for: detailWin.window!)
        
        while NSApp.runModalSession(session) == NSApplication.ModalResponse.continue {
            print("...")
            
            NSApp.endModalSession(session)
        }
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        
        
        let view =  collectionView.makeSupplementaryView(ofKind: NSCollectionView.SupplementaryElementKind.sectionHeader,
                                                         withIdentifier: NSUserInterfaceItemIdentifier.init("index_header"), for: indexPath)
        
        return view
    }
    
    
}
extension IndexViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return self.indexSections.count == 0 ? NSZeroSize : NSSize(width: 450, height: 65)
    }
}
