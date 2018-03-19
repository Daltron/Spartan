//
//  SpartanRequestRetrier.swift
//  SpartanExample
//
//  Created by Dalton Hinterscher on 3/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Alamofire
import AlamoRecord

public class SpartanRequestRetrier: RequestRetrier {
    
    // [Request url: Number of times retried]
    private var retriedRequests: [String: Int] = [:]
    
    public func should(_ manager: SessionManager,
                         retry request: Request,
                         with error: Error,
                         completion: @escaping RequestRetryCompletion) {
        
        guard request.task?.response == nil, let url = request.request?.url?.absoluteString else {
            removeCachedUrlRequest(url: request.request?.url?.absoluteString)
            completion(false, 0.0) // don't retry
            return
        }
        
        guard let retryCount = retriedRequests[url] else {
            retriedRequests[url] = 1
            completion(true, 1.0) // retry after 1 second
            return
        }
        
        if retryCount <= 3 {
            retriedRequests[url] = retryCount + 1
            completion(true, 1.0) // retry after 1 second
        } else {
            removeCachedUrlRequest(url: url)
            completion(false, 0.0) // don't retry
        }
        
    }
    
    private func removeCachedUrlRequest(url: String?) {
        guard let url = url else {
            return
        }
        retriedRequests.removeValue(forKey: url)
    }

}

extension SpartanRequestRetrier: RequestObserver {
    
    public func onRequestFinished(with url: String) {
        removeCachedUrlRequest(url: url)
    }
}
