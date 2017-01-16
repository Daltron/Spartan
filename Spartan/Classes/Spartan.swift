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

public class Spartan: NSObject {

    /* Token that is included with each request that requires OAuth authentication. If the request you make requies OAuth and this is nil, the response status code will be a 401 Unauthorized
     */
    public static var authorizationToken: String?
    
    /* When enabled, will log each network request and its response in the console */
    public static var loggingEnabled: Bool = true
    
    
    /*
     Maps an album with the given id
        @param id: The id of the album you are wanting to map
        @param success: The callback that is called if the mapping was successfull
        @param failure: The callback that is called if the mapping failed or if the stock symbol provided is not valid
     */
    
    public class func getAlbum(id: String, success:@escaping ((SpartanAlbum) -> Void), failure:@escaping ((SpartanError) -> Void)) -> Request {
        return SpartanAlbum.find(id, success: success, failure: failure)
    }
    
    public class func getAlbums(ids: [String], success:@escaping (([SpartanAlbum]) -> Void), failure:@escaping ((SpartanError) -> Void)) -> Request {
        let parameters = ["ids" : ids.joined(separator: ",")]
        return SpartanAlbum.all(parameters: parameters, success: success, failure: failure)
    }
    
}
