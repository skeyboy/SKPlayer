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
    var state: String?
    var kind: String?
    var mains: String?
    var lang: String?
    var imdb: String?
    var des: String?
    var resources: Resuorces = Resuorces()
}
extension Detail{
    var isEmpty: Bool {
        return  !isNotEmpty
    }
    var isNotEmpty: Bool{
        return !resources.cloudPlayer.isEmpty || !resources.cloudDown.isEmpty
    }
}
class Resuorces{
    var cloudPlayer: [CloudPlayer] = [CloudPlayer]()
    var cloudDown: [CloudDown] = [CloudDown]()
}
class CloudPlayer{
    var link: String?
    var title: String?
}
typealias CloudDownFailure = ()->Void
class CloudDown: CloudPlayer, Parser {
    
    //直接使用迅雷等可用的下载软件下载
    func open(success:@escaping ([BT])->Void, failure:CloudDownFailure? = nil){
        parser(HOST_URL+link!.replacingOccurrences(of: "down", with: "downlist")) { (ji, resp, error) in
            //            /html/body/p[2]
            var bts:[BT] = [BT]()
            
            if let magnent = ji?.xPath("//div[@class='down123']/a"){
                for item in magnent {
                    
                    let btURL =  item.attributes["href"]
                    let title = item.xPath("./text()").first?.rawContent!
                    if btURL!.hasPrefix("thunder") || btURL!.hasPrefix("magnet"){
                        //                    NSWorkspace.shared.open(URL.init(string: btURL!)!)
                        let bt: BT = BT.init(title: title!, bt: btURL!)
                        bts.append(bt)
                    }
                }
                success(bts)
            }else{
                if let failure = failure {
                    failure()
                }
            }
        }
    }
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
            let year = ji?.xPath("//div[@class='vod_intro rt']/h1[1]/span[@class='year']/text()")?.first?.rawContent!
            
            detail.year =  self.digitalFrom(stringValue: year!, callBack: { (souceValue, result) -> String in
                
                return  NSMutableString.init(string: souceValue).substring(with: result.range)
            }).first
            
            detail.des = ji?.xPath("//div[@class='c05']/span/text()")?.first?.rawContent ?? "暂无简介"
            detail.lang = ji?.xPath("//div[@class='vod_intro rt']/dl/dd[5]/a/text()")?.first?.rawContent
            detail.imdb = ji?.xPath("//div[@class='vod_intro rt']/dl/dd[6]/text()")?.first?.rawContent ?? UnKnown
            detail.mains = (ji?.xPath("//div[@class='vod_intro rt']/dl/dd[@class='zhuyan']/a/text()")!.map({ (node) -> String in
                return node.rawContent!
            }).joined(separator: "\t"))
            detail.update = ji?.xPath("//div[@class='vod_intro rt']/dl/dd[1]/text()")?.first?.rawContent
            detail.state = ji?.xPath("//div[@class='vod_intro rt']/dl/dd[2]/text()")?.first?.rawContent
            detail.kind = (ji?.xPath("//div[@class='vod_intro rt']/dl/dd[3]/a/text()")!.map({ (node) -> String in
                return node.rawContent!
            }).joined(separator: "\t"))
            
            self.detailParseVidlist(query, cloudResults: { (coludPlayers, cloudDowns) in
                detail.resources.cloudPlayer.append(contentsOf: coludPlayers)
                detail.resources.cloudDown.append(contentsOf:cloudDowns)
                result(detail)
                
            })
            
            
        }
    }
    func detailParseVidlist(_ lastPathComponent: String, cloudResults:@escaping ([CloudPlayer], [CloudDown])->Void) ->Void{
        
        
        //        vidlist/13243.html
        let pathComponent =    digitalFrom(stringValue: lastPathComponent) {  (souceValue, result) -> String in
            
            return  NSMutableString.init(string: souceValue).substring(with: result.range).appending(".html")
            }.first!
        let url: String = HOST_URL + "/vidlist/" + pathComponent
        parser(url) { (ji, resp, error) in
            var cloudPlayers:[CloudPlayer] = [CloudPlayer]()
            var cloudDowns:[CloudDown] = [CloudDown]()
            if ji == nil {
                cloudResults(cloudPlayers, cloudDowns)
                
            }else{
                let cloudNodes:[JiNode]? = (ji?.xPath("//ul[@class='p_list_03']/li/a"))
                let cloudDownNodes: [JiNode]? = (ji?.xPath("//ul[@class='p_list_02']/li/a"))
                if(cloudNodes != nil){
                    for cloudNode in cloudNodes! {
                        let cloudPlayer: CloudPlayer = CloudPlayer()
                        cloudPlayer.link = cloudNode.attributes["href"]
                        cloudPlayer.title = cloudNode.attributes["title"]
                        cloudPlayers.append(cloudPlayer)
                    }
                }
                if cloudDownNodes != nil {
                    for cloudNode in cloudDownNodes! {
                        let cloudDown: CloudDown = CloudDown()
                        cloudDown.link = cloudNode.attributes["href"]
                        cloudDown.title = cloudNode.attributes["title"]
                        cloudDowns.append(cloudDown)
                    }
                }
                cloudResults(cloudPlayers,cloudDowns)
                
            }
            
        }
    }
}

