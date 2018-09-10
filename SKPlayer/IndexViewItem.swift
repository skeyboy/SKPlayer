//
//  IndexViewItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class IndexViewItem: NSCollectionViewItem {
    
    var indexModel: IndexItemModel? {
        didSet{
            
            loader.load(url: self.indexModel!.linkPicUrl ?? "https://goss.veer.com/creative/vcg/veer/800water/veer-152382107.jpg", into: self.indexCoverImageView)
            
//            self.indexCoverImageView.image = NSImage.init(contentsOf: URL.init(string: self.indexModel!.linkPicUrl ?? "https://goss.veer.com/creative/vcg/veer/800water/veer-152382107.jpg")!)
//
            self.indexCoverTitleView.stringValue = indexModel!.title!

        }
    }
    @IBOutlet weak var indexCoverImageView: NSImageView!
    
    @IBOutlet weak var indexCoverTitleView: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.indexCoverImageView.image = NSImage.init(contentsOf: URL.init(string: "https://goss.veer.com/creative/vcg/veer/800water/veer-152382107.jpg")!)
    }
    
}
