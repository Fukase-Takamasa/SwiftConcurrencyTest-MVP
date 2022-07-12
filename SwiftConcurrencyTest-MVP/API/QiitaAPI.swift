//
//  QiitaAPI.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import Foundation
import Alamofire

enum QiitaAPI: URLRequestConvertible {
    
    case getAuthorizedUser
    case getArticles(queryParameters: [String: String]?)
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIConst.BASE_URL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        
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
        case .getAuthorizedUser:
            return .get
        case .getArticles:
            return .get
        }
    }

    private var path: String {
        switch self {
        case .getAuthorizedUser:
            return APIConst.GET_AUTHORIZED_USER
        case .getArticles:
            return APIConst.GET_ARTICLES
        }
    }
    
    private var parameters: [String: String]? {
        switch self {
        case .getAuthorizedUser:
            return [:]
        case .getArticles(let parameters):
            return parameters
        }
    }
    
    private var headers: HTTPHeaders {
        return ["Authorization": "Bearer \(Const.personalAccessToken)"]
    }
}
