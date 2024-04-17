//
//  APIManager.swift
//  ImageCaching
//
//  Created by Ravi Seta on 15/04/24.
//


import Foundation

enum ResponseHandler<T: Decodable> {
    case success(result: T)
    case failure(error: String)
}

struct APIConfig {
    static var accessKey: String = "iqfGRvBw0nwneX_RVfpv0uTSWVW7xDopKDNzTbLGOBI"
}

class APIManager {
    
    func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(APIConfig.accessKey)"
        return headers
    }
    
    func request<T: Decodable>(endPoint: APIEndPoint, parameter: Encodable?) async throws -> T {
        
        let request = try self.prepareURLRequest(from: endPoint, parameters: parameter)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
    
    private func prepareURLRequest(from endPoint: APIEndPoint, parameters: Encodable?) throws -> URLRequest {
        
        guard let url = URL(string: endPoint.route) else { throw APIError.invalidURLRequest }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.httpMethod
        request.httpBody = try parameters?.toData()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("\n")
        print("REQUEST URL :: \(endPoint.route)")
        //        print("REQUEST PARAM :: \(parameters?.toJSON() ?? [:])")
        print("\n")
        
        return request
    }
    
    func requestUsingQuery<T: Decodable>(endPoint: APIEndPoint, parameter: Encodable?) async throws -> T {
        
        let request = try self.prepareQueryURLRequest(from: endPoint, parameters: parameter)
        
        let (data, res) = try await URLSession.shared.data(for: request)
        let statusCode = (res as? HTTPURLResponse)?.statusCode ?? 0
        
        switch statusCode {
        case 200:
            let response = try JSONDecoder().decode(T.self, from: data)
            return response
            
        default:
            let error: String = String(data: data, encoding: .utf8) ?? "Error!"
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])
        }
        
    }
    
    private func prepareQueryURLRequest(from endPoint: APIEndPoint, parameters: Encodable?) throws -> URLRequest {
        
        guard let url = URL(string: endPoint.route) else { throw APIError.invalidURLRequest }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if let parameters = parameters {
            components.query = queryParameters(parameters.toDictionary())
        }
        
        var request = URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        request.httpMethod = endPoint.httpMethod
        request.allHTTPHeaderFields = self.prepareHeaders()
        return request
    }
    
    private func queryParameters(_ parameters: [String: Any]?, urlEncoded: Bool = false) -> String {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: ".-_")
        
        var query = ""
        parameters?.forEach { key, value in
            let encodedValue: String
            if let value = value as? String {
                encodedValue = urlEncoded ? value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "" : value
            } else {
                encodedValue = "\(value)"
            }
            query = "\(query)\(key)=\(encodedValue)&"
        }
        return query
    }
}


extension Encodable {
    
    func toData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) -> [String: Any] {
        do {
        
            let data = try encoder.encode(self)
            let object = try JSONSerialization.jsonObject(with: data)
            if let json = object as? [String: Any]  { return json }
            
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
            
        } catch {
            return [:]
        }
        
    }
}
