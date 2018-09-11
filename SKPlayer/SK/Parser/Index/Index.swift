//
//  INdex.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Foundation
import Ji
class IndexItemModel: CustomDebugStringConvertible, CustomStringConvertible{
    var linkPicUrl: String?
    var link: String?
    var title: String?
    var debugDescription: String{
        return  "debugDescription::\(description)"
    }
    var description: String{
        return "\(String(describing: linkPicUrl)) \(String(describing: link)) \(String(describing: title))"
    }
}
class Section {
    var title:String?
    var link: String?
    var sectionItems:[IndexItemModel] = [IndexItemModel]()
}
func indexParser(_ url: String = "http://www.btbtdy.net/", results:@escaping ([Section])->Void)->Void{
    var sectionResults: [Section] = [Section]()
    
    URLSession.shared.dataTask(with: URL.init(string: url)!) { (data, resp, error) in
        
        let ji =  Ji.init(data: data, isXML: false)
        
        let sections: [JiNode] =    (ji?.xPath("//div[@class='index_ui_2']/div[@class='cts']"))!
        
        for section in sections {
            let titleItems: [JiNode] = section.xPath("./div[@class='cts_a01']/ul[@class='cts_a01_1 hd']/li/text()")
            var itemsContents: [JiNode] = section.xPath("./div[@class='cts_a02 bd']")
            var index = 0
            for title in titleItems {
                if index == itemsContents.count {
                    continue
                }
                let innerSection: Section = Section()
                
                innerSection.title = title.rawContent!
                
                let contentsItems = (itemsContents[index] as JiNode).xPath("./ul[@class='cts_list list_lis']")
                    for li in contentsItems {
                        let lis = li.xPath("./li")
                            for lisItem in lis {
                                let indexItemModel: IndexItemModel = IndexItemModel()
                                var linkPicUrl =      lisItem.xPath(".//*/img").first?.attributes["src"]
                                if linkPicUrl == nil {
                                    linkPicUrl = lisItem.xPath(".//*/img").first?.attributes["data-original"]
                                }
                                if linkPicUrl == nil {
                                    linkPicUrl = lisItem.xPath(".//img").first?.attributes["data-src"]
                                }
                                let link =  lisItem.xPath("./div[@class='liimg']/a[@class='pic_link']").first?.attributes["href"]
                                let title =   lisItem.xPath("./div[@class='liimg']/a[@class='pic_link']").first?.attributes["title"]
                                indexItemModel.linkPicUrl = linkPicUrl
                                indexItemModel.link = link
                                indexItemModel.title = title
                                innerSection.sectionItems.append(indexItemModel)
                            }
                        
                    }
                sectionResults.append(innerSection)
                
                index = index + 1
            }
        }
        DispatchQueue.main.async {
            results(sectionResults)
        }
        }.resume()
}

