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

public class PagingObject<T: Paginatable> : Mappable  {
    
    public private(set) var href: String!
    public private(set) var items: [T]!
    public private(set) var limit: Int!
    public private(set) var next: String?
    public private(set) var offset: Int!
    public private(set) var previous: String?
    public private(set) var total: Int!
    public private(set) var cursors: CursorsObject?
    
    public var canMakeNextRequest: Bool {
        return next != nil
    }
    
    public var canMakePreviousRequest: Bool {
        return previous != nil
    }
    
    public required init?(map: Map) {
        mapping(map: map)
    }
    
    public func mapping(map: Map) {
        href <- map["href"]
        items <- map["items"]
        limit <- map["limit"]
        next <- map["next"]
        offset <- map["offset"]
        previous <- map["previous"]
        total <- map["total"]
        cursors <- map["cursors"]
    }
    
    public func getNext(success: @escaping ((PagingObject<T>) -> Void), failure: ((SpartanError) -> Void)?) -> Request? {
        
        if let next = next {
            return SpartanRequestManager.mapObject(.get, urlString: next, keyPath: T.pluralRoot, success: success, failure: failure)
        } else {
            if let failure = failure {
                let error = SpartanError(errorType: .other, errorMessage: "PagingObject does not have a next URL")
                failure(error)
            }
        }
        
        return nil
    }
    
    public func getPrevious(success: @escaping ((PagingObject<T>) -> Void), failure: ((SpartanError) -> Void)?) -> Request? {
        
        if let previous = previous {
            return SpartanRequestManager.mapObject(.get, urlString: previous, keyPath: T.pluralRoot, success: success, failure: failure)
        } else {
            if let failure = failure {
                let error = SpartanError(errorType: .other, errorMessage: "PagingObject does not have a previous URL")
                failure(error)
            }
        }
        
        return nil
    }
}
