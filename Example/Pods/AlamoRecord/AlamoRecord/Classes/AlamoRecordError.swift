/*
 
 The MIT License (MIT)
 Copyright (c) 2017 Tunespeak
 
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

open class AlamoRecordError: NSError, Mappable {
    
    override open var description: String {
        guard let nsError = nsError else {
            return "[AlamoRecordError] No description could be found for this error."
        }
        return "[AlamoRecordError] \(nsError.localizedDescription)"
    }
    
    /// The error of the failed request
    public var nsError: NSError?
    
    public required init() {
        super.init(domain: "", code: -1, userInfo: [:])
    }
    
    required public init(nsError: NSError) {
        super.init(domain: nsError.domain, code: nsError.code, userInfo: nsError.userInfo)
        self.nsError = nsError
    }
    
    required public init?(map: Map) {
        super.init(domain: "", code: -1, userInfo: [:])
        mapping(map: map)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func mapping(map: Map) {}
}
