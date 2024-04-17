//
//  APIEndPoint.swift
//  ImageCaching
//
//  Created by Ravi Seta on 15/04/24.
//

import Foundation

enum APIEndPoint {
    case fetchPhotos
    
    private var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var route: String {
        var endPoint: String = ""
        switch self {
        case .fetchPhotos:
            endPoint = "collections/317099/photos"
        }
        return self.baseURL + endPoint
    }
    
    var httpMethod: String {
        switch self {
        case .fetchPhotos:
            "GET"
        }
    }
}
