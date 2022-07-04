//
//  QiitaAPI.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Alamofire

enum QiitaAPI: URLRequestConvertible {
    
    case articles
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIConst.BASE_URL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    private var method: HTTPMethod {
        switch self {
        case .articles:
            return .get
        }
    }

    private var path: String {
        switch self {
        case .articles:
            return APIConst.ARTICLES
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .articles:
            return [:]
        }
    }
}
