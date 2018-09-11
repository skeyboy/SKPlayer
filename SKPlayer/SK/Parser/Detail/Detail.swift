//
//  Detail.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Foundation
import Ji

class Detail{
    var coverSrc: String?
    var title: String?
    var year: String?
}
typealias DetailResult = (Detail)->Void
class DetailParser: Parser{
    
    func detailParser( _ query: String, result: @escaping DetailResult) -> Void {
        var realURL: String = HOST_URL
        realURL += query
        parser(realURL) { (ji, resp, error) in
            let detail: Detail = Detail()
            
           detail.coverSrc = ji?.xPath("//div[@class='vod_img lf']/img")?.first!.attributes["src"]
            detail.title = ji?.xPath("//div[@class='vod_intro rt']/h1[1]/text()")?.first?.rawContent
            var year = ji?.xPath("//div[@class='vod_intro rt']/h1[1]/span[@class='year']/text()")?.first?.rawContent
         detail.year =  self.digitalFrom(stringValue: year!, callBack: { (souceValue, result) -> String in
                
                return  NSMutableString.init(string: souceValue).substring(with: result.range)
            }).first
            
            result(detail)
            
        }
    }
}

