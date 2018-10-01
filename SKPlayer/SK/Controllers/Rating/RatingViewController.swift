//
//  RatingViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/28.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Ji
class RatingViewController: NSViewController {
    var link: String?
    var items: [Rate] = [Rate]()
    
    @IBOutlet weak var titieView: NSTextField!
    @IBOutlet weak var ratingView: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.titieView.stringValue = title ?? UnKnown

    }
    
    func fetch() -> Void {
        if let link = link {
            self.view.showProgressHUD(title: "", message: "数据更新中……", mode: ProgressHUDMode.determinate)

            self.pareseRating(link) { (rates) in
                self.items.removeAll()
                self.items.append(contentsOf: rates)
                MainQueue.async {
                    
                    self.ratingView.reloadData()
                }
                
                self.view.hideProgressHUD()

            }
        }
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        
       
    }
}
extension RatingViewController: NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let indexPath = indexPaths.first!
        
        let rate = self.items[indexPath.item]
        
        
        
        let detailWin: DetailWindowController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("detail_window")) as! DetailWindowController
        let detailVC: DetailViewController = detailWin.contentViewController as! DetailViewController
        
        
        detailVC.detailDoor = (rate.title, rate.href) as? DetailDoor
        
//        self.presentViewControllerAsModalWindow(detailVC)
        let session = NSApp.beginModalSession(for: detailWin.window!)

        while NSApp.runModalSession(session) == NSApplication.ModalResponse.continue {
            print("...")

            NSApp.endModalSession(session)
        }

    }
}
extension RatingViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let viewItem: RateViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("RateViewItem"), for: indexPath) as! RateViewItem
        
        return viewItem
    }
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        let viewItem = item as! RateViewItem
        
        let rate = self.items[indexPath.item]
        
        viewItem.rate = rate
    }
    
    
}
extension RatingViewController: Parser {
    func pareseRating(_ href: String, result:@escaping ([Rate])->Void) -> Void {
        self.parser(HOST_URL+href) { (ji, resp, error) in
            print("\(resp?.url)")
            
            if let ji = ji {
                if let ratelist =   ji.xPath("//div[@class='p_listnew']/ul[@class='new-ul']/li") {
                    if  ratelist.count == 1 {
                        result([Rate]())
                        return
                    }
                    let values =    ratelist[1 ... ratelist.count - 1].map({ (node) -> Rate in
                        
                        var info = node.xPath("./div[@class='name']/a").first!
                   let title =     info.xPath("./text()").first?.rawContent ?? UnKnown
                     let href =   info.attributes["href"]
                        
                        let em = node.xPath("//em[@class='em']/text()").first?.rawContent
                        
                        let year = self.value(for: "year", with: node)
                        let area = self.value(for: "area", with: node)
                        let score = self.value(for: "score", with: node)
                        let type = self.value(for: "type", with: node)
                        let starring = self.value(for: "starring", with: node)
                        let time = self.value(for: "time", with: node)
                        
                        
                        let rate: Rate = Rate()
                       
                        rate.title = title
                        rate.em = em
                        rate.year = year
                        rate.area = area
                        rate.score = score
                        rate.type = type
                        rate.starring = starring
                        rate.time = time
                        rate.href = href
                        
                        return rate
                    })
                    result(values)
                }
            }
        }
    }
    func value(for item:String, with node:JiNode) -> String {
       return node.xPath("./div[@class='\(item)']/text()").first?.rawContent ?? UnKnown
    }
}
