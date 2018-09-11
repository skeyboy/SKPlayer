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
    var update: String?
    var des: String?
    var resources: Resuorces = Resuorces()
}
class Resuorces{
    var cloudPlayer: [CloudPlayer] = [CloudPlayer]()

}
class CloudPlayer{
    var link: String?
    var title: String?
    
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
            
            detail.des = ji?.xPath("//div[@class='c05']/span/text()")?.first?.rawContent ?? "暂无简介"
            
            self.detailParseVidlist(query, cloudResults: { (coluds) in
                detail.resources.cloudPlayer.append(contentsOf: coluds)
                result(detail)

            })
            
            
        }
    }
    func detailParseVidlist(_ lastPathComponent: String, cloudResults:@escaping ([CloudPlayer])->Void) ->Void{

     
//        vidlist/13243.html
        let pathComponent =    digitalFrom(stringValue: lastPathComponent) {  (souceValue, result) -> String in
            
            return  NSMutableString.init(string: souceValue).substring(with: result.range).appending(".html")
        }.first!
        let url: String = HOST_URL + "/vidlist/" + pathComponent
        parser(url) { (ji, resp, error) in
            var clouds:[CloudPlayer] = [CloudPlayer]()

            if ji == nil {
                cloudResults(clouds)
                
            }else{
            var cloudNodes:[JiNode]? = (ji?.xPath("//ul[@class='p_list_03']/li/a"))
            if(cloudNodes != nil){
                for cloudNode in cloudNodes! {
                    let cloudPlayer: CloudPlayer = CloudPlayer()
                    cloudPlayer.link = cloudNode.attributes["href"]
                    cloudPlayer.title = cloudNode.attributes["title"]
                    clouds.append(cloudPlayer)
                }
                cloudResults(clouds)
                }
                
            }

        }
    }
}

