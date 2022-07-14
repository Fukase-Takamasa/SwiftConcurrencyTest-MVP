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
    case getArticles(queryParameters: Parameters?)
    case getLgtmUsers(articleId: String)
    
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
        default:
            return .get
        }
    }

    private var path: String {
        switch self {
        case .getAuthorizedUser:
            return APIConst.GET_AUTHORIZED_USER
        case .getArticles:
            return APIConst.GET_ARTICLES
        case .getLgtmUsers(let articleId):
            return "\(APIConst.GET_ARTICLES)/\(articleId)/likes"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .getArticles(let parameters):
            return parameters
        default:
            return [:]
        }
    }
    
    private var headers: HTTPHeaders {
        return ["Authorization": "Bearer \(Const.personalAccessToken)"]
    }
}
