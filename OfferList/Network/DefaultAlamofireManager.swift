//
//  DefaultAlamofireManager.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import Foundation
import Alamofire

class DefaultAlamofireManager: Alamofire.Session {
    static let sharedManager: DefaultAlamofireManager = {
        var headers = HTTPHeaders.default
        headers.update(HTTPHeader.userAgent(HTTPHeader.defaultUserAgent.value.encodeUrl() ?? ""))
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache?.removeAllCachedResponses()
        configuration.httpAdditionalHeaders = headers.dictionary
        configuration.timeoutIntervalForRequest = TimeInterval(NetworkManager.REQUEST_TIMEOUT) // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = TimeInterval(NetworkManager.CALL_BACK_TIMEOUT) // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
