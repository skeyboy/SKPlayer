//
//  LatestViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/19.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class LatestViewController: NSViewController, Parser {
    @IBOutlet weak var todayCollectionView: NSCollectionView!
    var todays:[Today] = [Today]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.parseToday(url: "http://www.btbtdy.net/previews.html#today") { (ts) in
            self.todays.append(contentsOf: ts)
            MainQueue.async {
                
                self.todayCollectionView.reloadData()
            }
        }
    }
    
}

extension LatestViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.todays.isEmpty {
            return 0
        }
        return self.todays[section].items.count
    }
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return self.todays.count
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let latestItem: LatestViewItem =    collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("LatestViewItem"), for: indexPath) as! LatestViewItem
        let todayItem: TodayItem = self.todays[indexPath.section].items[indexPath.item]
        
        latestItem.todayItem = todayItem
        return latestItem
    }
}
extension LatestViewController: NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        let todayItem: TodayItem = self.todays[indexPaths.first!.section].items[indexPaths.first!.item]
        
        let detailWin: DetailWindowController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("detail_window")) as! DetailWindowController
        let detailVC: DetailViewController = detailWin.contentViewController as! DetailViewController
        
        
        detailVC.detailDoor = (todayItem.title, todayItem.href) as? DetailDoor
        let session = NSApp.beginModalSession(for: detailWin.window!)
        
        while NSApp.runModalSession(session) == NSApplication.ModalResponse.continue {
            print("...")
            
            NSApp.endModalSession(session)
        }
    }
}
