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

public class AudioFeaturesObject: SpartanBaseObject {
    
    override class var root: String {
        return "audio-feature"
    }

    public private(set) var danceability: Double?
    public private(set) var energy: Double?
    public private(set) var key: Int?
    public private(set) var loudness: Double?
    public private(set) var mode: Int?
    public private(set) var speechiness: Double?
    public private(set) var acousticness: Double?
    public private(set) var instrumentalness: Double?
    public private(set) var liveness: Double?
    public private(set) var valence: Double?
    public private(set) var tempo: Double?
    public private(set) var trackHref: String?
    public private(set) var analysisUrl: String?
    public private(set) var durationMs: Int?
    public private(set) var timeSignature: Int?
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        danceability <- map["danceability"]
        energy <- map["energy"]
        key <- map["key"]
        loudness <- map["loudness"]
        mode <- map["mode"]
        speechiness <- map["speechiness"]
        acousticness <- map["acousticness"]
        instrumentalness <- map["instrumentalness"]
        liveness <- map["liveness"]
        valence <- map["valence"]
        tempo <- map["tempo"]
        trackHref <- map["track_href"]
        analysisUrl <- map["analysis_url"]
        durationMs <- map["duration_ms"]
        timeSignature <- map["time_signature"]
    }
}
