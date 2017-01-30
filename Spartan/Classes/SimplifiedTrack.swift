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

public class SimplifiedTrack: SpartanBaseObject {
    
    override class var root: String {
        return "track"
    }
    
    public private(set) var artists: [SimplifiedArtist]!
    public private(set) var availableMarkets: [String]!
    public private(set) var discNumber: Int!
    public private(set) var durationMs: Int!
    public private(set) var explicit: Bool!
    public private(set) var externalUrls: [String : String]!
    public private(set) var isPlayable: Bool?
    public private(set) var linkedFrom: LinkedTrackObject?
    public private(set) var name: String!
    public private(set) var previewUrl: String!
    public private(set) var trackNumber: Int!
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        artists <- map["artists"]
        availableMarkets <- map["available_markets"]
        discNumber <- map["disc_number"]
        durationMs <- map["duration_ms"]
        explicit <- map["explicit"]
        externalUrls <- map["external_urls"]
        isPlayable <- map["is_playable"]
        linkedFrom <- map["linked_from"]
        name <- map["name"]
        previewUrl <- map["preview_url"]
        trackNumber <- map["track_number"]
    }
}
