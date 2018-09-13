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
    var btTitle: String{
        if title.hasPrefix("magnet") {
            return "磁力链接"
        }
        return "种子"
    }
}
