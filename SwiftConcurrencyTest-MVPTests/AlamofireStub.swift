//
//  AlamofireStub.swift
//  SwiftConcurrencyTest-MVPTests
//
//  Created by ウルトラ深瀬 on 22/7/22.
//

import Foundation
import Alamofire

class AlamofireStub: Alamofire.Session {
    static let shared: AlamofireStub = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            return configuration
        }()
        return AlamofireStub(configuration: configuration)
    }()
}
