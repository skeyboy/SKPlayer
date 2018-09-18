//
//  IndexViewItem.swift
//  SKPlayer
//
//  Created by sk on 2018/9/10.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
let ImgHolderURL = "https://goss.veer.com/creative/vcg/veer/800water/veer-152382107.jpg"
class IndexViewItem: NSCollectionViewItem {
    var indexPath: IndexPath?
    var indexModel: IndexItemModel?{
        didSet{
            loader.load(url: self.indexModel!.linkPicUrl ?? "https://goss.veer.com/creative/vcg/veer/800water/veer-152382107.jpg", into: self.indexCoverImageView)
            self.indexCoverTitleView.stringValue = indexModel!.title ?? "未知"
            self.indexCoverScoreView.stringValue = indexModel!.score
            self.indexCoverDesView.stringValue = indexModel!.des
        }
    }
    @IBOutlet weak var indexCoverImageView: NSImageView!
    
    @IBOutlet weak var indexCoverTitleView: NSTextField!
    
    @IBOutlet weak var indexCoverScoreView: NSTextField!
    
    @IBOutlet weak var indexCoverDesView: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.indexCoverImageView.image = NSImage.init(contentsOf: URL.init(string: "https://goss.veer.com/creative/vcg/veer/800water/veer-152382107.jpg")!)
        self.view.wantsLayer = true

        self.view.layer?.borderWidth = 1
        self.view.layer?.borderColor = NSColor.lightGray.cgColor
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: NSCollectionViewLayoutAttributes) -> NSCollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.frame = NSRect(x: 0, y: 0, width:IndexSectionSize.width, height: IndexSectionSize.height)
       
        return attributes

    }
}
