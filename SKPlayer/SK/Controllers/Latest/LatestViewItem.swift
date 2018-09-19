//
//  LatestViewItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/19.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Kingfisher
class LatestViewItem: NSCollectionViewItem {
    @IBOutlet weak var picView: NSImageView!
    @IBOutlet weak var descView: NSTextField!
    @IBOutlet weak var titleView: NSTextField!
    @IBOutlet weak var scoreView: NSTextField!
    @IBOutlet weak var infoView: NSTextField!
    @IBOutlet weak var rtView: NSTextField!
    var todayItem: TodayItem? {
        didSet{
            if let url = URL.init(string: self.todayItem!.picLink!){
                
                self.picView.kf.setImage(with: url)
            }
            self.titleView.stringValue = self.todayItem!.title ?? UnKnown
            self.descView.stringValue = self.todayItem!.totalDesc ?? UnKnown
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    
}
