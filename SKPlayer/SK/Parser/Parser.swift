//
//  Parser.swift
//  SKPlayer
//
//  Created by sk on 2018/9/11.
//  Copyright © 2018 sk. All rights reserved.
//

import Foundation
import Ji
import Alamofire
var SKParserTaskContainer:[String:DataRequest] = [String: DataRequest]()
protocol Parser {
    
}
extension Parser{
    public func digitalFrom<T>(stringValue: String, pattern: String = "\\d{1,100}", callBack:(String, NSTextCheckingResult)->T ) -> [T] {
        
        //        let pattern = "\\d/\\d&nbsp"
        
        var arr = [T]()
        let regularEx = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        //        let stringValue = ""
        let matchResult =   regularEx.matches(in: stringValue,
                                              options: NSRegularExpression.MatchingOptions.reportProgress,
                                              range: NSRange.init(location: 0, length: stringValue.count)
        )
        for result in matchResult {
            arr.append( callBack(stringValue, result) )
        }
        return arr
    }
}
typealias ParserResult = (Ji?, URLResponse?, Error?)-> Void
extension Parser{
    func parser(_ url:String, result: @escaping ParserResult) -> Void {
        
        if let request = SKParserTaskContainer[url] {
            request.resume()
        }
        
        let request = Alamofire.request(url)
        SKParserTaskContainer[url] = request
        request.responseData { (resp) in
            if resp.result.isSuccess {
                let ji =  Ji.init(data: resp.result.value, isXML: false)
                SKParserTaskContainer[url] = nil
                result(ji, resp.response, resp.error)
             }
            }.downloadProgress { (progress) in
                
        }
        //    URLSession.shared.dataTask(with: URL.init(string: url)!) { (data, resp, error) in
        //
        //        let ji =  Ji.init(data: data, isXML: false)
        //
        //        result(ji, resp, error)
        //
        //        }.resume()
        
    }
}
