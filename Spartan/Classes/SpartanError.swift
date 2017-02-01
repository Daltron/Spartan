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

public enum SpartanErrorType {
    case unauthorized
    case other
}

public class SpartanError: NSObject, Mappable {
    
    private let ERROR_PREFIX = "SpartanError:"
    
    override open var description: String {
        return "\(ERROR_PREFIX) \(errorMessage!)"
    }
    
    private var statusCode: Int!
    public private(set) var errorType: SpartanErrorType!
    public private(set) var errorMessage: String!
    
    init(error: Error) {
        super.init()
        errorMessage = error.localizedDescription
        determineErrorType(statusCode: (error as NSError).code)
    }
    
    init(errorType: SpartanErrorType, errorMessage: String) {
        super.init()
        self.errorType = errorType
        self.errorMessage = errorMessage
    }
    
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    public func mapping(map: Map) {
        statusCode <- map["error.status"]
        errorMessage <- map["error.message"]
        determineErrorType(statusCode: statusCode)
    }
    
    private func determineErrorType(statusCode: Int) {
        if statusCode == 401 {
            errorType = .unauthorized
        } else {
            errorType = .other
        }
    }
    
    class func parseSpotifyError(data: Data?, error: Error, statusCode: Int? = nil) -> SpartanError {
        
        let spartanError: SpartanError!
        do {
            if let data = data {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                if json is [String : Any] {
                    spartanError = Mapper<SpartanError>().map(JSON: json as! [String : Any])
                } else {
                    spartanError = SpartanError(error: error)
                }
                
            } else {
                spartanError = SpartanError(error: error)
            }
            return spartanError
        } catch {
            return SpartanError(error: error)
        }
    }
}
