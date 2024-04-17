//
//  APIError.swift
//  ImageCaching
//
//  Created by Ravi Seta on 15/04/24.
//

import Foundation

enum APIError: Error, LocalizedError {
    
    case invalidURLRequest
    
    public var errorDescription: String? {
        switch self {
        case .invalidURLRequest:
            return NSLocalizedString("Invalid URLRequest!", comment: "")
        }
    }
}
