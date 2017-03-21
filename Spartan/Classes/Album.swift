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

public class Album: SimplifiedAlbum {
    
    public private(set) var copyrights: [CopyrightObject]!
    public private(set) var externalIds: [String : String]!
    public private(set) var genres: [String]?
    public private(set) var label: String!
    public private(set) var popularity: Int!
    public private(set) var releaseDate: String!
    public private(set) var releaseDatePrecision: String!
    public private(set) var tracks: PagingObject<SimplifiedTrack>!

    public override func mapping(map: Map) {
        super.mapping(map: map)
        copyrights <- map["copyrights"]
        externalIds <- map["external_ids"]
        genres <- map["genres"]
        label <- map["label"]
        popularity <- map["popularity"]
        releaseDate <- map["release_date"]
        releaseDatePrecision <- map["release_date_precision"]
        tracks <- map["tracks"]
    }
}
