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
        let all = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("all")) as! AllViewController
        let rate =  self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("skpage")) as! SKPageController
        let new =  self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("skpage")) as! SKPageController
        
        addSubChildController(index as! NSViewController)
        addSubChildController(latest as! NSViewController)
        addSubChildController(all as NSViewController)
        addSubChildController(rate )
        addSubChildController(new )

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
        case .allView:
            ( self.childViewControllers[type.rawValue] as! AllViewController).newHref = href
            break
            
        case .rate:
            let pageVC: SKPageController = self.childViewControllers[type.rawValue] as! SKPageController
            pageVC.titles = ["日排行榜首页","电影日排行","电视剧日排行","动漫日排行","3D电影日排行","蓝光原盘日排行"]
            pageVC.items =  ["/hot/","/hot/dianying/","/hot/dianshiju/","/hot/dongman/","/hot/3ddianying/","/hot/languang/"]
            break
        case .new:
            
            let pageVC: SKPageController = self.childViewControllers[type.rawValue] as! SKPageController
            pageVC.titles = ["最新榜首页","最新电影","最新电视剧","最新动漫","最新3D电影","最新蓝光原盘"]
            pageVC.items =  ["/new/","/new/dianying/","/new/dianshiju/","/new/dongman/","/new/3ddianying/","/new/languang/"]
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
