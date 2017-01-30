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

public enum AlbumType : String {
    case album = "album"
    case single = "single"
    case appearsOn = "appears_on"
    case compilation = "compilation"
}

public class SimplifiedAlbum: SpartanBaseObject {
    
    override class var root: String {
        return "album"
    }
    
    public private(set) var albumType: String!
    public private(set) var artists: [SimplifiedArtist]!
    public private(set) var availableMarkets: [String]!
    public private(set) var externalUrls: [String : String]!
    public private(set) var images: [SpartanImage]!
    public private(set) var name: String!

    override public func mapping(map: Map) {
        super.mapping(map: map)
        albumType <- map["album_type"]
        artists <- map["artists"]
        availableMarkets <- map["available_markets"]
        externalUrls <- map["external_urls"]
        images <- map["images"]
        name <- map["name"]
    }

}
