//
//  ViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import SnapKit
class ViewController: NSViewController {
    var menuVC : MenuViewController?
    
    @IBOutlet weak var contentView: NSView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.menuVC = self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("menu")) as? MenuViewController
        self.addChildViewController(self.menuVC!)
        self.menuVC?.removeFromParentViewController()
        self.view.addSubview(self.menuVC!.view)
        self.menuVC?.view.snp.makeConstraints({ (maker) in
            maker.top.left.bottom.equalTo(self.view)
            maker.width.equalTo(100)
        })
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.top.right.bottom.equalTo(self.view)
            maker.left.equalTo((self.menuVC?.view.snp.right)!)
        }
     let index =   self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("index"))
     
        addSubChildController(index as! NSViewController)
        
       
    }
    func addSubChildController(_ childController: NSViewController){
        self.addChildViewController(childController)
        self.contentView.addSubview(childController.view)
        childController.view.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.contentView.snp.edges)
            maker.height.width.greaterThanOrEqualTo(300)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
extension NSViewController{}

@objc protocol CollectionViewMenu {
    @objc optional  func collectionView( collectionView: NSCollectionView, menuForItems itmes:Set<IndexPath>) -> NSMenu
    @objc optional func collection( collection: NSCollectionView, rightClickForItem item:IndexPath)
}
extension CollectionViewMenu where Self:NSCollectionView{
    func menu(forEvent event:NSEvent) -> NSMenu? {
        let location = self.convert(event.locationInWindow, from: nil)
        let indexPath = self.indexPathForItem(at: location)
        if let indexPath = indexPath, event.type == .rightMouseDown {
            self.selectItems(at: [indexPath], scrollPosition: NSCollectionView.ScrollPosition.centeredHorizontally)
            if self.responds(to: #selector(collectionView(collectionView:menuForItems:))){
                return   self.collectionView(collectionView: self, menuForItems: [indexPath])
            }
        }
        return self.superview?.menu(for: event)
    }
     func rightMouseDown(with event: NSEvent){
        let location = self.convert(event.locationInWindow, from: nil)
        let indexPath = self.indexPathForItem(at: location)
        if  let indexPath = indexPath,  event.type == .rightMouseDown {
            self.selectItems(at: [indexPath], scrollPosition: NSCollectionView.ScrollPosition.centeredHorizontally)
            if self.responds(to: #selector(collection(collection:rightClickForItem:))){
                return   self.collection(collection: self, rightClickForItem: indexPath)
            }
        }
        self.superview?.rightMouseDown(with: event)
    }
    
}

extension NSCollectionView : CollectionViewMenu{
    func collection(collection: NSCollectionView, rightClickForItem item: IndexPath) {
        
    }
    func collectionView(collectionView: NSCollectionView, menuForItems itmes: Set<IndexPath>) -> NSMenu {
        let menu: NSMenu = NSMenu(title: "Title")
        let item = NSMenuItem(title: "查看", action: nil, keyEquivalent: "")
        menu.addItem(item)
        return menu
    }
}
