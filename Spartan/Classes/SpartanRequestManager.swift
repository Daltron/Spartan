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
import ObjectMapper
import AlamofireObjectMapper

class SpartanRequestManager: NSObject {

    private static var _manager: Alamofire.SessionManager?
    class var manager: Alamofire.SessionManager {
        get {
            if _manager == nil {
                let configuration = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
                configuration.timeoutIntervalForRequest = 30.0   // How long to wait on server's response
                configuration.timeoutIntervalForResource = 30.0  // How long to wait for client to make request
                _manager = Alamofire.SessionManager(configuration: configuration)
                _manager!.startRequestsImmediately = true
                _manager!.adapter = SpartanRequestAdapater()
            }
            
            return _manager!
        }
    }
    
    private class func generalRequest(_ method: Alamofire.HTTPMethod, urlString: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default) -> DataRequest {
        let request = manager.request(urlString, method: method, parameters: parameters, encoding: encoding).validate()
        SpartanRequestLogger.logPendingRequest(request: request)
        return request
    }
    
    class func makeRequest(_ method: Alamofire.HTTPMethod, urlString: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> DataRequest {
        return generalRequest(method, urlString: urlString, parameters: parameters, encoding: encoding).responseJSON(completionHandler: { (response: DataResponse<Any>) in
            
            SpartanRequestLogger.logFinishedRequest(response: response)
            if response.response!.statusCode >= 200 && response.response!.statusCode <= 299 {
                if let success = success {
                    success()
                }
            } else {
                if let failure = failure {
                    failure(SpartanError.parseSpotifyError(data: response.data, error: response.result.error!))
                }
            }
        })
    }
    
    class func mapBoolArray(_ method: Alamofire.HTTPMethod, urlString: String, parameters: [String: Any]? = nil, success: (([Bool]) -> Void)?, failure: ((SpartanError) -> Void)?) -> DataRequest {
        
        return generalRequest(method, urlString: urlString).responseJSON { response in
            SpartanRequestLogger.logFinishedRequest(response: response)
            if response.result.isSuccess {
                if let success = success {
                    success(response.result.value! as! [Bool])
                }
            } else {
                if let failure = failure {
                    failure(SpartanError.parseSpotifyError(data: response.data, error: response.result.error!))
                }
            }
        }
    }

    class func mapObject<T: Mappable>(_ method: Alamofire.HTTPMethod, urlString: String, keyPath: String? = nil, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, success: ((T) -> Void)?, failure: ((SpartanError) -> Void)?) -> DataRequest {
        
        return generalRequest(method, urlString: urlString, parameters: parameters, encoding: encoding).responseObject(keyPath: keyPath, completionHandler: { (response: DataResponse<T>) in
            SpartanRequestLogger.logFinishedRequest(response: response)
            switch response.result {
                case .success:
                    handleSuccessfulResponse(success: success, response: response)
                case .failure(let error):
                    handleFailedResponse(error: error, response: response, failure: failure)
            }
        })
    }
    
    class func mapObjects<T: Mappable>(_ method: Alamofire.HTTPMethod, urlString: String, keyPath: String? = nil, parameters: [String: Any]? = nil, success: (([T]) -> Void)?, failure: ((SpartanError) -> Void)?) -> DataRequest {
        
        return generalRequest(method, urlString: urlString, parameters: parameters).responseArray(keyPath: keyPath, completionHandler: { (response: DataResponse<[T]>) in
            SpartanRequestLogger.logFinishedRequest(response: response)
            switch response.result {
                case .success:
                    handleSuccessfulResponse(success: success, response: response)
                case .failure(let error):
                    handleFailedResponse(error: error, response: response, failure: failure)
            }
        })
    }
    
    private class func handleSuccessfulResponse(success: (() -> Void)?, response: DataResponse<Any>) {
        if let success = success {
            success()
        }
    }
    
    private class func handleSuccessfulResponse<T: Mappable>(success: ((T) -> Void)?, response: DataResponse<T>) {
        if let success = success {
            success(response.result.value!)
        }
    }
    
    private class func handleSuccessfulResponse<T: Mappable>(success: (([T]) -> Void)?, response: DataResponse<[T]>) {
        if let success = success {
            success(response.result.value!)
        }
    }
    
    private class func handleFailedResponse(error: Error, response: DataResponse<Any>, failure: ((SpartanError) -> Void)?){
        if let failure = failure {
            failure(SpartanError.parseSpotifyError(data: response.data, error: error, statusCode: response.response?.statusCode))
        }
    }
    
    private class func handleFailedResponse<T : Mappable>(error: Error, response: DataResponse<T>, failure: ((SpartanError) -> Void)?){
        if let failure = failure {
            failure(SpartanError.parseSpotifyError(data: response.data, error: error, statusCode: response.response?.statusCode))
        }
    }

    private class func handleFailedResponse<T : Mappable>(error: Error, response: DataResponse<[T]>, failure: ((SpartanError) -> Void)?){
        if let failure = failure {
            failure(SpartanError.parseSpotifyError(data: response.data, error: error, statusCode: response.response?.statusCode))
        }
    }

}
