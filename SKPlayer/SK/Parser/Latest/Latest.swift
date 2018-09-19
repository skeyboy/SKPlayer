//
//  Latest.swift
//  SKPlayer
//
//  Created by sk on 2018/9/19.
//  Copyright © 2018 sk. All rights reserved.
//

import Foundation
import Ji
class Today{
    var today: String?
    var items:[TodayItem] = [TodayItem]()
}
class TodayItem{
    var picLink: String?
    var totalDesc: String?
    var href: String?
    var title: String?
}
extension Parser{
    func parseToday(url: String, result ts:@escaping ([Today])->Void) -> Void {
        parser(url) { (ji, resp, error) in
            let list = ji?.xPath("//div[@class='gengxin']/dl")
            var todays: [Today] = [Today]()
            if let list = list {
                
                for li in list  {
                    let today: Today = Today()
                    
                    today.today = li.xPath("./dt/text()").first!.rawContent
                    for item in li.xPath("./dd/ul[@class='cts_list list_liss']/li") {
                        let  img: JiNode = item.xPath("./div[@class='liimgs']/a/img").first!
                        
                        let href = item.xPath("./div[@class='liimgs']/a").first!.attributes["href"]
                        let title = img.attributes["alt"]
                        let pic = img.attributes["data-src"]
                        let totalDesc = item.xPath("./div[@class='liimgs']/a/span/text()").first!.rawContent!
                        
                        let todayItem = TodayItem()
                        todayItem.picLink = pic
                        todayItem.totalDesc = totalDesc
                        todayItem.title = title
                        todayItem.href = href
                        today.items.append(todayItem)
                        
                    }
                    todays.append(today)
                }
                
            }
            ts(todays)
        }
    }
}
