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

import ObjectMapper

public class SimplifiedPlaylist: SpartanBaseObject {
    
    override class var root: String {
        return "playlist"
    }

    public private(set) var isCollaborative: Bool!
    public private(set) var externalUrls: [String : String]!
    public private(set) var images: [SpartanImage]!
    public private(set) var owner: PublicUser!
    public private(set) var isPublic: Bool?
    public private(set) var name: String!
    public private(set) var snapshotId: String!
    public private(set) var tracksObject: TracksObject!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        isCollaborative <- map["collaborative"]
        externalUrls <- map["external_urls"]
        images <- map["images"]
        owner <- map["owner"]
        isPublic <- map["public"]
        name <- map["name"]
        snapshotId <- map["snapshot_id"]
        tracksObject <- map["tracks"]
    }
}
