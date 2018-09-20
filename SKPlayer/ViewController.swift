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
    var containerVC: ContainerController?
    @IBOutlet weak var searchView: QXSearchField!
    @IBOutlet weak var contentView: NSView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchView.recentSearches = ["32","法撒旦法师"]
        self.searchView.searchFocus = {() in
            
        }
        self.searchView.search = {(query) in
            
        }
        // Do any additional setup after loading the view.
        self.searchView.delegate = self
        self.menuVC = self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("menu")) as? MenuViewController
        self.addChildViewController(self.menuVC!)
        self.menuVC?.removeFromParentViewController()
        self.view.addSubview(self.menuVC!.view)
        self.menuVC?.view.snp.makeConstraints({ (maker) in
            maker.top.left.bottom.equalTo(self.view)
            maker.width.equalTo(100)
        })

        self.containerVC = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("ContainerController")) as? ContainerController
        self.addSubChildController(self.containerVC!)
        
        self.menuVC?.contentVC = self.containerVC
       

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
extension ViewController: NSSearchFieldDelegate{
    override func controlTextDidChange(_ obj: Notification) {
        
    }
    override func controlTextDidBeginEditing(_ obj: Notification) {
        
    }
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        
    }
}
extension NSViewController{}
