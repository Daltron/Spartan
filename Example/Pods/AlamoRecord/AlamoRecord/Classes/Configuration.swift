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

import Alamofire

open class Configuration: NSObject {
    
    /// See URLSessionConfiguration Documentation
    public var urlSessionConfiguration: URLSessionConfiguration!
    
    /// See Alamofire.RequestRetrier Documentation
    public var requestRetrier: RequestRetrier?
    
    /// See Alamofire.RequestAdapter Documentation
    public var requestAdapter: RequestAdapter?
    
    /// The status codes this configuration should ignore for failed requests
    public var ignoredErrorCodes: [Int] = []
    
    /// Observer that gets called after each requests finishes
    public var statusCodeObserver: StatusCodeObserver?
    
    /// Observer that gets called after each requests finishes
    public var requestObserver: RequestObserver?
    
    public override init() {
        super.init()
        
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "AlamoRecord"
        let randomId = UUID.init().uuidString // Need a random id in case multiple request manager instances are created
        urlSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "\(bundleIdentifier)-\(randomId).background")
        urlSessionConfiguration.timeoutIntervalForRequest = 30.0
        urlSessionConfiguration.timeoutIntervalForResource = 30.0
    }
    
    public convenience init(builder: (Configuration) -> ()) {
        self.init()
        builder(self)
    }
}
