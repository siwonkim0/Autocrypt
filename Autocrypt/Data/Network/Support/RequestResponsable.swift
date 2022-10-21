//
//  RequestResponsable.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

protocol RequestResponsable: Requestable, Responsable {}

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String: String]? { get }
}

extension Requestable {
    func url() throws -> URL {
        let fullPath = baseURL + path
        guard var urlComponents = URLComponents(string: fullPath) else {
            throw NetworkError.invalidURL
        }
        if let queryParameters = try queryParameters?.toDictionary() {
            let queries = queryParameters.map { URLQueryItem(name: $0, value: "\($1)") }
            urlComponents.queryItems = queries
        }
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    func urlRequest() throws -> URLRequest {
        let url = try url()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let bodyParameters = try bodyParameters?.toDictionary(), !bodyParameters.isEmpty {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
        }
        return request
    }
}

protocol Responsable {
    associatedtype Response: Decodable
}
