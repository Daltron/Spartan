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

public class AudioAnalysis: Mappable {
    
    class var root: String {
        return "audio-analysis"
    }

    public private(set) var bars: [AudioAnalysisBar]!
    public private(set) var beats: [AudioAnalysisBeat]!
    public private(set) var meta: AudioAnalysisMeta!
    public private(set) var sections: [AudioAnalysisSection]!
    public private(set) var segments: [AudioAnalysisSegment]!
    public private(set) var tatums: [AudioAnalysisTatum]!
    public private(set) var track: AudioAnalysisTrack!
    
    public required init?(map: Map) {
        mapping(map: map)
    }
    
    public func mapping(map: Map) {
        bars <- map["bars"]
        beats <- map["beats"]
        meta <- map["meta"]
        sections <- map["sections"]
        segments <- map["segments"]
        tatums <- map["tatums"]
        track <- map["track"]
    }
}
