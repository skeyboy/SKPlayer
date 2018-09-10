//
//  ImageLoader.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Foundation
import Cocoa
let loader: ImageLoader = ImageLoader()
class ImageLoader{
    let semp = DispatchSemaphore(value: 100)
    let group = DispatchGroup()
    let queue = DispatchQueue.init(label: "com.sk", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
    fileprivate init() {
        
    }
    public func load(url: String, into imageView:  NSImageView) {
        semp.wait(timeout: DispatchTime.distantFuture)
        URLSession.shared.dataTask(with: URL.init(string: url)!) { (data, resp, error) in
            DispatchQueue.main.async {
                
            imageView.image = NSImage.init(data: data!)
            }
            
            self.semp.signal()
        }.resume()
    }
}
