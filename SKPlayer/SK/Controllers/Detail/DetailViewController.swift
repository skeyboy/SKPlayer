//
//  DetailViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
import Kingfisher
class DetailViewController: NSViewController {
    let parser:DetailParser = DetailParser()
    
    @IBOutlet weak var yearView: NSTextField!
    @IBOutlet weak var titleView: NSTextField!
    @IBOutlet weak var coverImageView: NSImageView!
    var model: IndexItemModel?{
        didSet{
            self.view.window?.title = model?.title ?? "详情"
            self.parser.detailParser((model?.link!)!) { (detail) in
                self.coverImageView.kf.setImage(with: URL.init(string: detail.coverSrc!)!)
                self.titleView.stringValue = detail.title!
                self.yearView.stringValue = detail.year!
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    override func viewDidAppear() {
        super.viewDidAppear()
       
    }
}
