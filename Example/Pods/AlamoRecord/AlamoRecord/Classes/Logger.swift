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

class Logger: NSObject {

    /// If true, each request will be logged to the console
    static var loggingEnabled: Bool = true
    
    /// The prefix of each request that is logged to the console
    fileprivate static let loggerPrefix = "[AlamoRecordLogger]"
    
    /*
        Logs a request that just started to the console
        - parameter request: The request to log to the console
    */
    class func logRequest(request: DataRequest) {
        guard let httpMethod = request.request?.httpMethod, let url = request.request?.url else {
            print("[AlamoRecordLogger] The request appears to invalid. Please check your URL and try again.")
            return
        }
        if loggingEnabled {
            print("🔵 \(loggerPrefix) \(httpMethod) \(url.absoluteString)")
        }
    }
    
    /*
        Logs a finished request that just started to the console
        - parameter response: The response to log to the console
     */
    class func logFinishedResponse<AnyObject>(response: DataResponse<AnyObject>) {
        guard let responseObject = response.response else {
            return
        }
        
        if loggingEnabled {
            let method = response.request!.httpMethod!
            let urlString = response.request!.url!.absoluteString
            let statusCode = responseObject.statusCode
            let statusCodeString = statusCodeStrings[statusCode]
            let duration = String(response.timeline.totalDuration)
            let trimmedDuration = duration.substring(to: duration.index(duration.startIndex, offsetBy: 4))
            print("\(emoji(for: statusCode)) \(loggerPrefix) \(method) \(urlString) (\(statusCode) \(statusCodeString!)) \(trimmedDuration) seconds")            
        }
    }
    
    /*
        Helper function that returns an emoji based on the given status code
        parameter statusCode: The status code of the finished request
     */
    fileprivate class func emoji(for statusCode: Int) -> String {
        if statusCode >= 200 && statusCode <= 299 {
            return "⚪️"
        } else {
            return "🔴"
        }
    }
    
    /// All status code definitions
    fileprivate static let statusCodeStrings =
        [100: "Continue",
         101: "Switching Protocols",
         102: "Processing",
         200: "OK",
         201: "Created",
         202: "Accepted",
         203: "Non-Authoritative Information",
         204: "No Content",
         205: "Reset Content",
         206: "Partial Content",
         207: "Multi-Status",
         208: "Already Reported",
         226: "IM Used",
         300: "Multiple Choices",
         301: "Moved Permanently",
         302: "Found",
         303: "See Other",
         304: "Not Modified",
         305: "Use Proxy",
         306: "Switch Proxy",
         307: "Temporary Redirect",
         308: "Permanent Redirect",
         400: "Bad Request",
         401: "Unauthorized",
         402: "Payment Required",
         403: "Forbidden",
         404: "Not Found",
         405: "Method Not Allowed",
         406: "Not Acceptable",
         407: "Proxy Authentication Required",
         408: "Request Timeout",
         409: "Conflict",
         410: "Gone",
         411: "Length Required",
         412: "Precondition Failed",
         413: "Request Entity Too Large",
         414: "Request-URI Too Long",
         415: "Unsupported Media Type",
         416: "Requested Range Not Satisfiable",
         417: "Expectation Failed",
         418: "I'm a teapot",
         420: "Enhance Your Calm",
         422: "Unprocessable Entity",
         423: "Locked",
         424: "Method Failure",
         425: "Unordered Collection",
         426: "Upgrade Required",
         428: "Precondition Required",
         429: "Too Many Requests",
         431: "Request Header Fields Too Large",
         451: "Unavailable For Legal Reasons",
         500: "Internal Server Error",
         501: "Not Implemented",
         502: "Bad Gateway",
         503: "Service Unavailable",
         504: "Gateway Timeout",
         505: "HTTP Version Not Supported",
         506: "Variant Also Negotiates",
         507: "Insufficient Storage",
         508: "Loop Detected",
         509: "Bandwidth Limit Exceeded",
         510: "Not Extended",
         511: "Network Authentication Required",
         521: "Web Server Is Down"]

}
