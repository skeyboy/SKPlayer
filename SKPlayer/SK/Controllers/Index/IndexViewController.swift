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
let IndexSectionSize = NSSize(width: 216, height: 352)
class IndexViewController: NSViewController {
    var session: NSApplication.ModalSession?
    var indexs:[[IndexItemModel]] = [[IndexItemModel]]()
    var indexParts:[Part] = [Part]()
    @IBOutlet weak var indexCollection: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        //        let layout: NSCollectionViewGridLayout = NSCollectionViewGridLayout.init()
        //        layout.maximumItemSize = NSSize(width: 300, height: 200)
        //        layout.minimumItemSize = NSSize(width: 150, height: 100)
        //
        let layout:NSCollectionViewFlowLayout = NSCollectionViewFlowLayout()
        layout.itemSize = IndexSectionSize
        layout.estimatedItemSize = IndexSectionSize
        layout.sectionHeadersPinToVisibleBounds = true
        
        layout.sectionHeadersPinToVisibleBounds = true
        self.indexCollection.collectionViewLayout = layout
        
        
        indexParser("http://www.btbtdy.net/") { (results) in
            
            self.indexParts.insert(contentsOf: results, at: 0)
            self.indexCollection.reloadData()
        }
    }
    
}

extension IndexViewController: NSCollectionViewDelegate{}
extension IndexViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentSection: Section? = self.indexParts[section].currentSection
        if let currentSection = currentSection {
            return   currentSection.sectionItems.count
        }
        return 0
    }
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return indexParts.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        
        let item:IndexViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("IndexViewItem"), for: indexPath) as! IndexViewItem
        
        let currentSection: Section = self.indexParts[indexPath.section].currentSection!
        
        let indexModel: IndexItemModel = currentSection.sectionItems[indexPath.item]
        item.indexModel = indexModel
        item.indexPath = indexPath
        
        return item
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("items select")
        collectionView.deselectItems(at: indexPaths)
        
        
        let indexPath = indexPaths.first!
        let currentSection: Section = self.indexParts[indexPath.section].currentSection!
        
        let section: Section = currentSection
        
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
        let view: IndexHeaderView = collectionView.makeSupplementaryView(ofKind: NSCollectionView.SupplementaryElementKind.sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IndexHeaderView"), for: indexPath) as! IndexHeaderView
        view.indexPath = indexPath
        view.currentIndex = self.indexParts[indexPath.section].currentIndex
        view.headerCallBack = {(item, path) in
            
            self.indexParts[path.section].currentIndex = item
            let sect =  IndexSet.init(integersIn: Range<Int>.init(NSMakeRange(path.section, 1))!)
            self.indexCollection.reloadSections(sect)
        }
 
            view.sectionTitles = self.indexParts[indexPath.section].sections.map({ (s) -> String in
                return s.title!
            })
        
        return view
    }
    
}

extension IndexViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return self.indexParts[section].sections.isEmpty ? NSZeroSize : NSSize(width: 450, height: 45)
    }
}

extension NSCollectionViewItem{
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        view.layer?.borderColor = NSColor.white.cgColor
        // 2
        view.layer?.borderWidth = 0.0
        
        self.addObserver(self, forKeyPath: "self.isSelected", options: .new, context: nil)
    }
    
}
