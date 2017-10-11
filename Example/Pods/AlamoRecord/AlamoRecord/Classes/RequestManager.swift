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
import AlamofireObjectMapper
import ObjectMapper

open class RequestManager<U: URLProtocol, E: AlamoRecordError>: NSObject {
    
    public typealias Parameters = [String: Any]
    
    /// If enabled, each request will be logged to the console
    public var loggingEnabled: Bool = true {
        didSet {
            Logger.loggingEnabled = self.loggingEnabled
        }
    }
    
    /// The configuration object of the RequestManager
    public var configuration: Configuration!
    
    /// Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
    public var sessionManager: Alamofire.SessionManager!
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        sessionManager = Alamofire.SessionManager(configuration: configuration.urlSessionConfiguration)
        sessionManager.startRequestsImmediately = true
        sessionManager.retrier = configuration.requestRetrier
        sessionManager.adapter = configuration.requestAdapter
    }
    
    /**
        Makes a request to the given URL. Each request goes through this method first.
        - parameter method: The HTTP method
        - parameter url: The URL that conforms to URLProtocol
        - parameter parameters: The parameters. `nil` by default
        - parameter encoding: The parameter encoding. `URLEncoding.default` by default
        - parameter headers: The HTTP headers. `nil` by default
     */
    @discardableResult
    open func makeRequest(_ method: Alamofire.HTTPMethod,
                              url: U,
                              parameters: Parameters? = nil,
                              encoding: ParameterEncoding = URLEncoding.default,
                              headers: HTTPHeaders? = nil) -> DataRequest {
  
        let request = sessionManager.request(url.absolute,
                                             method: method,
                                             parameters: parameters,
                                             encoding: encoding,
                                             headers: headers).validate()
        Logger.logRequest(request: request)
        return request
    }
    
    /**
        Makes a request to the given URL
        - parameter method: The HTTP method
        - parameter url: The URL that conforms to URLProtocol
        - parameter parameters: The parameters. `nil` by default
        - parameter encoding: The parameter encoding. `URLEncoding.default` by default
        - parameter headers: The HTTP headers. `nil` by default
        - parameter emptyBody: Wether or not the response will have an empty body. `false` by default
        - parameter success: The block to execute if the request succeeds
        - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    open func makeRequest(_ method: Alamofire.HTTPMethod,
                          url: U,
                          parameters: Parameters? = nil,
                          encoding: ParameterEncoding = URLEncoding.default,
                          headers: HTTPHeaders? = nil,
                          emptyBody: Bool = false,
                          success: (() -> Void)?,
                          failure: ((E) -> Void)?) -> DataRequest {
        
        return makeRequest(method,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers)
            .responseJSON { response in
                
                Logger.logFinishedResponse(response: response)
                
                guard emptyBody else {
                    switch response.result {
                    case .success:
                        self.onSuccess(success: success, response: response)
                    case .failure(let error):
                        self.onFailure(error: error, response: response, failure: failure)
                    }
                    return
                }
                
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 299 {
                    self.onSuccess(success: success, response: response)
                } else {
                    self.onFailure(error: response.error!, response: response, failure: failure)
                }
        }
        
    }
    
    /**
         Makes a request and maps an object that conforms to the Mappable protocol
         - parameter method: The HTTP method
         - parameter url: The URL that conforms to URLProtocol
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func mapObject<T: Mappable>(_ method: Alamofire.HTTPMethod,
                         url: U,
                         parameters: Parameters? = nil,
                         keyPath: String? = nil,
                         encoding: ParameterEncoding = URLEncoding.default,
                         headers: HTTPHeaders? = nil,
                         success: ((T) -> Void)?,
                         failure: ((E) -> Void)?) -> DataRequest {
        
        return makeRequest(method,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers)
            .responseObject(keyPath: keyPath, completionHandler: { (response: DataResponse<T>) in
                            
                Logger.logFinishedResponse(response: response)
                switch response.result {
                    case .success:
                    self.onSuccess(success: success, response: response)
                case .failure(let error):
                    self.onFailure(error: error, response: response, failure: failure)
                }
            })
    }
    
    /**
         Makes a request and maps an array of objects that conform to the Mappable protocol
         - parameter method: The HTTP method
         - parameter url: The URL that conforms to URLProtocol
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func mapObjects<T: Mappable>(_ method: Alamofire.HTTPMethod,
                         url: U,
                         parameters: Parameters? = nil,
                         keyPath: String? = nil,
                         encoding: ParameterEncoding = URLEncoding.default,
                         headers: HTTPHeaders? = nil,
                         success: (([T]) -> Void)?,
                         failure: ((E) -> Void)?) -> DataRequest {
        
        return makeRequest(method,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers)
            .responseArray(keyPath: keyPath, completionHandler: { (response: DataResponse<[T]>) in
            
                Logger.logFinishedResponse(response: response)
                switch response.result {
                case .success:
                    self.onSuccess(success: success, response: response)
                case .failure(let error):
                    self.onFailure(error: error, response: response, failure: failure)
                }
            })
    }
    
    /**
         Makes a request and maps an AlamoRecordObject
         - parameter id: The id of the object to find
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func findObject<T: AlamoRecordObject<U, E>>(id: Any,
                          parameters: Parameters? = nil,
                          keyPath: String? = nil,
                          encoding: ParameterEncoding = URLEncoding.default,
                          headers: HTTPHeaders? = nil,
                          success:((T) -> Void)?,
                          failure:((E) -> Void)?) -> DataRequest {
        
        return findObject(url: T.urlForFind(id),
                          parameters: parameters,
                          keyPath: keyPath,
                          encoding: encoding,
                          headers: headers,
                          success: success,
                          failure: failure)
    }
    
    /**
         Makes a request and maps an AlamoRecordObject
         - parameter url: The URL that conforms to URLProtocol
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func findObject<T: AlamoRecordObject<U, E>>(url: U,
                                 parameters: Parameters? = nil,
                                 keyPath: String? = nil,
                                 encoding: ParameterEncoding = URLEncoding.default,
                                 headers: HTTPHeaders? = nil,
                                 success:((T) -> Void)?,
                                 failure:((E) -> Void)?) -> DataRequest {
        
        return mapObject(.get,
                         url: url,
                         parameters: parameters,
                         keyPath: keyPath,
                         encoding: encoding,
                         headers: headers,
                         success: success,
                         failure: failure)
    }
    
    /**
         Makes a request and maps an array of AlamoRecordObjects
         - parameter url: The URL that conforms to URLProtocol
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func findArray<T: Mappable>(_ url: U,
                         parameters: Parameters? = nil,
                         keyPath: String? = nil,
                         encoding: ParameterEncoding = URLEncoding.default,
                         headers: HTTPHeaders? = nil,
                         success:(([T]) -> Void)?,
                         failure:((E) -> Void)?) -> DataRequest {
        
        return mapObjects(.get,
                          url: url,
                          parameters: parameters,
                          keyPath: keyPath,
                          encoding: encoding,
                          headers: headers,
                          success: success,
                          failure: failure)
    }
    
    /**
         Makes a request and creates an AlamoRecordObjects
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func createObject<T: AlamoRecordObject<U, E>>(parameters: Parameters? = nil,
                            keyPath: String? = nil,
                            encoding: ParameterEncoding = URLEncoding.default,
                            headers: HTTPHeaders? = nil,
                            success:((T) -> Void)?,
                            failure:((E) -> Void)?) -> DataRequest {
        
        return createObject(url: T.urlForCreate(),
                         parameters: parameters,
                         keyPath: keyPath,
                         encoding: encoding,
                         headers: headers,
                         success: success,
                         failure: failure)
    }

    /**
         Makes a request and creates an AlamoRecordObject
         - paramter url: The URL that conforms to URLProtocol
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func createObject<T: AlamoRecordObject<U, E>>(url: U,
                                   parameters: Parameters? = nil,
                                   keyPath: String? = nil,
                                   encoding: ParameterEncoding = URLEncoding.default,
                                   headers: HTTPHeaders? = nil,
                                   success:((T) -> Void)?,
                                   failure:((E) -> Void)?) -> DataRequest {
        
        return mapObject(.post,
                         url: url,
                         parameters: parameters,
                         keyPath: keyPath,
                         encoding: encoding,
                         headers: headers,
                         success: success,
                         failure: failure)
    }
    
    /**
         Makes a request and creates the object
         - parameter parameters: The parameters. `nil` by default
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func createObject(url: U,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: HTTPHeaders? = nil,
                             success:(() -> Void)?,
                             failure:((E) -> Void)?) -> DataRequest {
        
        return makeRequest(.post,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers,
                           success: success,
                           failure: failure)
    }
    
    /**
         Makes a request and updates an AlamoRecordObject
         - parameter id: The id of the object to update
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func updateObject<T: AlamoRecordObject<U, E>>(id: Any,
                                 parameters: Parameters? = nil,
                                 keyPath: String? = nil,
                                 encoding: ParameterEncoding = URLEncoding.default,
                                 headers: HTTPHeaders? = nil,
                                 success:((T) -> Void)?,
                                 failure:((E) -> Void)?) -> DataRequest {
        
        return updateObject(url: T.urlForUpdate(id),
                         parameters: parameters,
                         keyPath: keyPath,
                         encoding: encoding,
                         headers: headers,
                         success: success,
                         failure: failure)
    }
    
    /**
         Makes a request and updates an AlamoRecordObject
         - parameter url: The URL that conforms to URLProtocol
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func updateObject<T: AlamoRecordObject<U, E>>(url: U,
                                 parameters: Parameters? = nil,
                                 keyPath: String? = nil,
                                 encoding: ParameterEncoding = URLEncoding.default,
                                 headers: HTTPHeaders? = nil,
                                 success:((T) -> Void)?,
                                 failure:((E) -> Void)?) -> DataRequest {
        
        return mapObject(.put,
                         url: url,
                         parameters: parameters,
                         keyPath: keyPath,
                         encoding: encoding,
                         headers: headers,
                         success: success,
                         failure: failure)
    }
    
    /**
     Makes a request and updates an AlamoRecordObject
     - parameter url: The URL that conforms to URLProtocol
     - parameter parameters: The parameters. `nil` by default
     - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
     - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
     - parameter headers: The HTTP headers. `nil` by default.
     - parameter success: The block to execute if the request succeeds
     - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func updateObject(url: U,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: HTTPHeaders? = nil,
                             success:(() -> Void)?,
                             failure:((E) -> Void)?) -> DataRequest {
        
        return makeRequest(.put,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers,
                           success: success,
                           failure: failure)
    }
    
    /**
         Makes a request and destroys an AlamoRecordObject
         - parameter url: The URL that conforms to URLProtocol
         - parameter parameters: The parameters. `nil` by default
         - parameter encoding: The parameter encoding. `URLEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func destroyObject(url: U,
                              parameters: Parameters? = nil,
                              encoding: ParameterEncoding = URLEncoding.default,
                              headers: HTTPHeaders? = nil,
                              success:(() -> Void)?,
                              failure:((E) -> Void)?) -> DataRequest {
        
        return makeRequest(.delete,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers,
                           success: success,
                           failure: failure)

    }
    
    /**
     Makes an upload request
     - parameter url: The URL that conforms to URLProtocol
     - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
     - parameter headers: The HTTP headers. `nil` by default.
     - parameter multipartFormData: The data to append
     - parameter progressHandler: Progress handler for following progress
     - parameter success: The block to execute if the request succeeds
     - parameter failure: The block to execute if the request fails
     */
    public func upload<T: Mappable>(url: U,
                       keyPath: String? = nil,
                       headers: HTTPHeaders? = nil,
                       multipartFormData: @escaping ((MultipartFormData) -> Void),
                       progressHandler: Request.ProgressHandler? = nil,
                       success: ((T) -> Void)?,
                       failure: ((E) -> Void)?) {
        
        sessionManager.upload(multipartFormData: multipartFormData, to: url.absolute, headers: headers) { (result) in
            switch result {
            case .success(let request, _, _):
                if let progressHandler = progressHandler {
                    request.uploadProgress(closure: progressHandler)
                }
                request.responseObject(keyPath: keyPath, completionHandler: { (response: DataResponse<T>) in
                    switch response.result {
                    case .success:
                        success?(response.result.value!)
                    case .failure(let error):
                        self.onFailure(error: error, response: response, failure: failure)
                    }
                })
            case .failure(let error):
                failure?(E(nsError: error as NSError))
            }
        }
    }
    
    /**
         Makes a download request
         - parameter url: The URL that conforms to URLProtocol
         - parameter destination: The destination to download the file to. If it is nil, then a default one will be assigned.
         - parameter progress: The progress handler of the download request
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    public func download(url: U,
                         destination: DownloadRequest.DownloadFileDestination? = nil,
                         progress: Request.ProgressHandler? = nil,
                         success: @escaping ((URL?) -> Void),
                         failure: @escaping ((E) -> Void)) {
        
        var finalDestination: DownloadRequest.DownloadFileDestination!
        if let destination = destination {
            finalDestination = destination
        } else {
            finalDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("default_destination")
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
        }
    
        sessionManager.download(url.absolute, to: finalDestination).downloadProgress(closure: { (prog) in
            progress?(prog)
        }).response { (response) in
            if let error = response.error {
                self.onFailure(error: error, response: response, failure: failure)
            } else {
                self.onSuccess(success: success, response: response)
            }
        }
    }

    /**
         Performs any logic associated with a successful DataResponse<Any>
         - parameter success: The block to execute if the request succeeds
         - parameter response: The response of the request
     */
    private func onSuccess(success: (() -> Void)?, response: DataResponse<Any>) {
        sendEventsToObservers(response: response.response)
        success?()
    }
    
    /**
         Performs any logic associated with a successful DataResponse<T>
         - parameter success: The block to execute if the request succeeds
         - parameter response: The response of the request
     */
    private func onSuccess<T: Mappable>(success: ((T) -> Void)?, response: DataResponse<T>) {
        sendEventsToObservers(response: response.response)
        success?(response.result.value!)
    }
    
    /**
         Performs any logic associated with a successful DataResponse<[T]>
         - parameter success: The block to execute if the request succeeds
         - parameter response: The response of the request
     */
    private func onSuccess<T: Mappable>(success: (([T]) -> Void)?, response: DataResponse<[T]>) {
        sendEventsToObservers(response: response.response)
        success?(response.result.value!)
    }
    
    /**
         Performs any logic associated with a successful DefaultDownloadResponse
         - parameter success: The block to execute if the request succeeds
         - parameter response: The response of the request
     */
    private func onSuccess(success: ((URL?) -> Void)?,
                           response: DefaultDownloadResponse) {
        sendEventsToObservers(response: response.response)
        success?(response.destinationURL)
    }
    
    /**
         Sends events to any observers that may exist on the configuration object
         - parameter response: The HTTPURLResponse
     */
    private func sendEventsToObservers(response: HTTPURLResponse?) {
        guard let response = response else {
            return
        }
        
        if let url = response.url?.absoluteString {
            configuration.requestObserver?.onRequestFinished(with: url)
        }
        
        configuration.statusCodeObserver?.onStatusCode(statusCode: response.statusCode, error: nil)
    }
    
    /**
         Performs any logic associated with a failed DataResponse<Any>
         - parameter error: The error the request returned
         - parameter response: The response of the request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure(error: Error,
                           response: DataResponse<Any>,
                           failure:((E) -> Void)?) {
        onFailure(error: error,
                  responseData: response.data,
                  statusCode: response.response?.statusCode,
                  failure: failure)
    }

    /**
         Performs any logic associated with a failed DataResponse<T>
         - parameter error: The error the request returned
         - parameter response: The response of the request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure<T: Mappable>(error: Error,
                                 response: DataResponse<T>,
                                 failure:((E) -> Void)?) {
        onFailure(error: error,
                  responseData: response.data,
                  statusCode: response.response?.statusCode,
                  failure: failure)
    }
    
    /**
         Performs any logic associated with a failed DataResponse<[T]>
         - parameter error: The error the request returned
         - parameter response: The response of the request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure<T: Mappable>(error: Error,
                                 response: DataResponse<[T]>,
                                 failure:((E) -> Void)?) {
        onFailure(error: error,
                  responseData: response.data,
                  statusCode: response.response?.statusCode,
                  failure: failure)
    }
    
    /**
         Performs any logic associated with a failed DefaultDownloadResponse
         - parameter error: The error the request returned
         - parameter response: The response of the request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure(error: Error,
                           response: DefaultDownloadResponse,
                           failure:((E) -> Void)?) {
        onFailure(error: error,
                  responseData: nil,
                  statusCode: response.response?.statusCode,
                  failure: failure)
    }
    
    /**
         Performs any logic associated with a failed request. All failed requests go through here.
         - parameter error: The error the request returned
         - parameter responseData: The responseData of the failed request
         - parameter statusCode: The statusCode of the failed request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure(error: Error,
                           responseData: Data?,
                           statusCode: Int?,
                           failure: ((E) -> Void)?) {
        
        let nsError = error as NSError
        if configuration.ignoredErrorCodes.contains(nsError.code) {
            return
        }
        
        let error: E = ErrorParser.parse(responseData, error: nsError)
        
        if let statusCode = statusCode {
            configuration.statusCodeObserver?.onStatusCode(statusCode: statusCode, error: error)
        }
        
        failure?(error)
    }

}
