//
//  ContainerController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/20.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class ContainerController: NSViewController {
    var currentType: Type = .indexView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let index =   self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("index"))
        
        let latest = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("latest"))
        
        addSubChildController(index as! NSViewController)
        addSubChildController(latest as! NSViewController)
        self.view.subviews[0].isHidden = false
    }
    func addSubChildController(_ childController: NSViewController){
        self.addChildViewController(childController)
        self.view.addSubview(childController.view)
        childController.view.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.view.snp.edges)
            //            maker.height.width.greaterThanOrEqualTo(300)
        }
        childController.view.isHidden = true
        
        
    }
    
    func change(type: Type, href: String ) -> Void {
        hiddenOthers(byType: type)
        switch type {
        case .indexView:
            showIndex(type: type)
            break
        case .latestView:
            showLatest(type: type)
            break
        case .menuView:
            
            break
        default:
            print("\(type) => \(href) \n")
        }
    }
    
    func hiddenOthers( byType type: Type) -> Void {
        if type == self.currentType || type.rawValue == self.childViewControllers.count {
            return
        }
        self.view.subviews.forEach { (sub) in
            sub.isHidden = true
        }
        self.view.subviews[type.rawValue].isHidden = false
        

        
        self.currentType = type
    }
}


// MARK: - 首页
extension ContainerController{
    func showIndex( type: Type ){
        self.view.subviews[type.rawValue].isHidden = false
    }
}

// MARK: - 带菜单页的播放列表
extension ContainerController{
    
}

// MARK: - 跟新列表
extension ContainerController{
    func showLatest(type: Type) -> Void {
        self.view.subviews[type.rawValue].isHidden = false
    }
    
}
