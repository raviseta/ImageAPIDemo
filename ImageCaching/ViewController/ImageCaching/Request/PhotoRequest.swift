//
//  PhotoRequest.swift
//  ImageCaching
//
//  Created by Ravi Seta on 16/04/24.
//

import Foundation

struct PhotoRequest: Encodable {
    
    let per_page: Int
    var page: Int
    
    static var `default`: PhotoRequest {
        return PhotoRequest(per_page: 10, page: 1)
    }
}

enum PhotoResponse {
    case success(Int)
    case failure(Error)
}

enum PhotoError: Error, LocalizedError {
    
    case finishedPaging
    
    public var errorDescription: String? {
        switch self {
        case .finishedPaging:
            return NSLocalizedString("No more page to load", comment: "")
        }
    }
}
