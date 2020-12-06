//
//  AppError.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import Foundation

enum AppError: Error, LocalizedError {
    case unknown
    case reason(String)
    case networkError(Int?, Error)
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .reason(let message):
            return message
        case .networkError(_, let error):
            return error.localizedDescription
        }
    }
}
