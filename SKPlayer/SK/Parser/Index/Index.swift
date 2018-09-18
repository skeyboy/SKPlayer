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
    var des: String = "暂无"
    var score: String = "0.0"
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
class Part{
    var currentIndex: Int = 0
    var sections:[Section] = [Section]()
}
extension Part{
    var currentSection: Section?{
        if sections.isEmpty {
            return nil
        }
        return sections[currentIndex]
    }
}
func indexParser(_ url: String = "http://www.btbtdy.net", results:@escaping ([Part])->Void)->Void{
    var partResults: [Part] = [Part]()
    URLSession.shared.dataTask(with: URL.init(string: url)!) { (data, resp, error) in
        
        let ji =  Ji.init(data: data, isXML: false)
        
        let sections: [JiNode] =    (ji?.xPath("//div[@class='index_ui_2']/div[@class='cts']"))!
        
        for section in sections {
            let titleItems: [JiNode] = section.xPath("./div[@class='cts_a01']/ul[@class='cts_a01_1 hd']/li/text()")
            var itemsContents: [JiNode] = section.xPath("./div[@class='cts_a02 bd']")
            
            let part = Part()
            var index = 0
            for _ in titleItems {
                if index == itemsContents.count {
                    continue
                }
              
               
                let contentsItems = (itemsContents[index] as JiNode).xPath("./ul[@class='cts_list list_lis']")
                
              
                var innerIndex = 0
                for li in contentsItems {
                    
                    let innerSection: Section = Section()
                    
                    innerSection.title = titleItems[innerIndex].rawContent!
                    
                    
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
                        
                        let score = lisItem.xPath("./div[@class='cts_ms']/p[@class='title']/span[1]/text()").first?.rawContent ?? UnKnown

                        let des = lisItem.xPath("./div[@class='cts_ms']/p[@class='des']/text()").first?.rawContent ?? UnKnown
                        
                        indexItemModel.linkPicUrl = linkPicUrl
                        indexItemModel.link = link
                        indexItemModel.title = title
                        indexItemModel.des = des
                        indexItemModel.score = score
                        innerSection.sectionItems.append(indexItemModel)
                    }
                    innerIndex = innerIndex + 1
                    part.sections.append(innerSection)
                }
                partResults.append(part)
                index = index + 1
            }
            
        }
        DispatchQueue.main.async {
            results(partResults)
        }
        }.resume()
}

