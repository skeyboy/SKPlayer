//
//  SKPageController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/28.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class SKPageController: NSPageController {
    var items:[String] = [String](){
        didSet{
            self.delegate = self
            
            self.arrangedObjects = self.items.map({ (rate) -> RatingViewController in
                
                let ratingVC: RatingViewController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.init("rating")) as! RatingViewController
                
                return ratingVC
            })
            
            self.selectedIndex = 0
            
        }
    }
    var titles:[String] = [String]()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        titles.append(contentsOf: ["日排行榜首页","电影日排行","电视剧日排行","动漫日排行","3D电影日排行","蓝光原盘日排行"])
//
//        items.append(contentsOf: ["/hot/","/hot/dianying/","/hot/dianshiju/","/hot/dongman/","/hot/3ddianying/","/hot/languang/"])
        
    }
    override func viewDidAppear() {
        super.viewDidAppear()
       
    }
}
extension SKPageController: NSPageControllerDelegate{
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        return NSPageController.ObjectIdentifier(rawValue: "\(self.selectedIndex)")
    }
    
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        let index = Int(identifier.rawValue)!
        let vc: RatingViewController = self.arrangedObjects[index] as! RatingViewController
        vc.link = items[index]
        vc.title = titles[index]
//        vc.fetch()
        return vc
    }
    public func pageController(_ pageController: NSPageController, prepare viewController: NSViewController, with object: Any?){
        if object != nil{
            let index = pageController.selectedIndex
        let vc: RatingViewController  = object as! RatingViewController
        vc.link = items[index]
        vc.title = titles[index]
            vc.fetch()
            
        }
    }
    public func pageControllerWillStartLiveTransition(_ pageController: NSPageController){
        
        
    }
     public func pageControllerDidEndLiveTransition(_ pageController: NSPageController){
        pageController.completeTransition()
    }
    func pageController(_ pageController: NSPageController, didTransitionTo object: Any) {
        let index = pageController.selectedIndex

         let vc: RatingViewController = self.arrangedObjects[index] as! RatingViewController
        vc.link = items[index]
        vc.title = titles[index]
        vc.fetch()
    }
}
