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

public class AudioAnalysisSection: Mappable {

    public private(set) var start: Double!
    public private(set) var duration: Double!
    public private(set) var confidence: Int!
    public private(set) var loudness: Double!
    public private(set) var tempo: Double!
    public private(set) var tempoConfidence: Double!
    public private(set) var key: Int!
    public private(set) var keyConfidence: Double!
    public private(set) var mode: Int!
    public private(set) var modeConfidence: Double!
    public private(set) var timeSignature: Int!
    public private(set) var timeSignatureConfidence: Int!
    
    required public init?(map: Map) {
        mapping(map: map)
    }
    
    public func mapping(map: Map) {
        start <- map["start"]
        duration <- map["duration"]
        confidence <- map["confidence"]
        loudness <- map["loudness"]
        tempo <- map["tempo"]
        tempoConfidence <- map["tempo_confidence"]
        key <- map["key"]
        keyConfidence <- map["key_confidence"]
        mode <- map["mode"]
        modeConfidence <- map["mode_confidence"]
        timeSignature <- map["time_signature"]
        timeSignatureConfidence <- map["time_signature_confidence"]
    }
}
