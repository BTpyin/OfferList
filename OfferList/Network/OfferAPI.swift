//
//  OfferAPI.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import Foundation
import Moya

enum API {
    case offerList
}

extension API: TargetType {
    var baseURL: URL {
        return BASE_URL
    }
    
    var path: String {
        switch self {
        case .offerList:
            return "/offer-list"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
            case .offerList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
