//
//  BT.swift
//  SKPlayer
//
//  Created by sk on 2018/9/13.
//  Copyright © 2018 sk. All rights reserved.
//

import Foundation
class BT{
    init( title: String, bt b:String) {
        self.title = title
        self.bt = b
    }
    var title: String = ""
    var bt: String
}
extension BT {
    var isBt: Bool{
    return bt.hasPrefix("thunder")
    }
    var isMagnet: Bool{
        return bt.hasPrefix("magnet")
    }
    var isLink: Bool{
        return !(isBt || isMagnet || isMiWifiMagnent)
    }
    var isMiWifiMagnent: Bool{
       return bt.hasPrefix("https://d.miwifi") ||  bt.hasPrefix("http://d.miwifi")
    }
    
    var btTitle: String{
        if isMagnet {
            return "磁力链接"
        }
        if isBt {
            return "BT资源"
        }
        if isMiWifiMagnent {
            return "小米路由资源"
        }
        return "其他"
    }
}

extension BT: Parser{
    func openMiWifi( mWifi:@escaping (BT)->Void) -> Void {
        parser(bt) { (ji, resp, error) in
        
            if let miWifiBt =  ji?.xPath("//span[@class='file-info-content']/text()")?.first?.rawContent {
                self.bt = miWifiBt
                mWifi(self)
            }
        
        }
    }
}
