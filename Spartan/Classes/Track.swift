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

public class Track: SimplifiedTrack {

    public private(set) var album: SimplifiedAlbum!
    public private(set) var externalIds: [String : String]!
    public private(set) var popularity: Int!
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        album <- map["album"]
        externalIds <- map["external_ids"]
        popularity <- map["popularity"]
    }
    
    override class func find<T: Mappable>(_ id: String, parameters: [String: Any]? = nil, success: ((T) -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        return SpartanRequestManager.mapObject(.get, urlString: urlForFind(id).stringValue, keyPath: Album.root, success: success, failure: failure)
    }
}
