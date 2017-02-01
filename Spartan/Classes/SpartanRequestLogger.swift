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

import Alamofire

class SpartanRequestLogger: NSObject {

    fileprivate static let LOGGER_PREFIX = "[SpartanRequestLogger]"
    
    class func logPendingRequest(request:DataRequest){
        if Spartan.loggingEnabled {
            let method = request.request!.httpMethod!
            let urlString = request.request!.url!.absoluteString
            print("🔵 \(LOGGER_PREFIX) \(method) \(sanitizedUrlString(urlString: urlString))")
        }
    }
    
    class func logFinishedRequest<AnyObject>(response:DataResponse<AnyObject>){
        if let responseObject = response.response {
            let method = response.request!.httpMethod!
            let urlString = response.request!.url!.absoluteString
            let statusCode = responseObject.statusCode
            let statusCodeString = STATUS_CODE_STRINGS[statusCode]
            let duration = response.timeline.totalDuration
            print("\(emoji(for: statusCode)) \(LOGGER_PREFIX) \(method) \(sanitizedUrlString(urlString: urlString)) (\(statusCode) \(statusCodeString!)) \(duration) seconds")
        }
    }
    
    private class func sanitizedUrlString(urlString: String) -> String {
        return urlString.components(separatedBy: "?").first!
    }
    
    private class func emoji(for statusCode:Int) -> String {
        if statusCode >= 200 && statusCode <= 299 {
            return "⚪️"
        } else {
            return "🔴"
        }
    }
    
    private static let STATUS_CODE_STRINGS =
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
