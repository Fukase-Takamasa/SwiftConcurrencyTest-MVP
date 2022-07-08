//
//  CustomError.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 8/7/22.
//

import Foundation

enum CustomError: Error, LocalizedError {
    case unexpectedServerError
    
    var errorTitle: String? {
        switch self {
        case .unexpectedServerError:
            return "エラー"
        default:
            return nil
        }
    }
    
    var errorSubMessage: String? {
        switch self {
        case .unexpectedServerError:
            return "サーバーでエラーが発生しました"
        default:
            return nil
        }
    }
    
    var completion: (() -> Void)? {
        switch self {
        default:
            return nil
        }
    }
}
