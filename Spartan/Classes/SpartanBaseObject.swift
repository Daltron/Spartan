/*
 
 The MIT License (MIT)
 Copyright (c) 2017 Dalton Hinterscher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Alamofire
import ObjectMapper

public class SpartanBaseObject: Paginatable {
    
    class var root: String {
        get { return "undefined" }
    }
    
    var root: String {
        get { return type(of: self).root }
    }
    
    public class var pluralRoot: String {
        get { return "\(root)s" }
    }
    
    var pluralRoot: String {
        get { return type(of: self).pluralRoot }
    }

    public private(set) var id: String!
    public private(set) var type: String!
    public private(set) var uri: String!
    public private(set) var href: String?
    
    public required init?(map: Map) {
        mapping(map: map)
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        uri <- map["uri"]
        href <- map["href"]
    }
    
    class func urlForFind(_ id: String) -> SpartanURL {
        return SpartanURL("\(pluralRoot)/\(id)")
    }
    
    class func urlForAll() -> SpartanURL {
        return SpartanURL(pluralRoot)
    }
    
    class func find<T: Mappable>(_ id: String, parameters: [String: Any]? = nil, success: ((T) -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        return SpartanRequestManager.mapObject(.get, urlString: urlForFind(id).stringValue, success: success, failure: failure)
    }
    
    class func all<T: Mappable>(parameters: [String: Any]? = nil, success: (([T]) -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        return SpartanRequestManager.mapObjects(.get, urlString: urlForAll().stringValue, keyPath: pluralRoot, parameters: parameters, success: success, failure: failure)
    }

    
}
