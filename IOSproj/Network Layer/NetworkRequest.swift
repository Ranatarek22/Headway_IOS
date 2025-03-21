//
//  NetworkRequest.swift
//  IOSproj
//
//  Created by Rana Tarek on 28/01/2025.
//
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkRequestError: LocalizedError, Equatable {
    case businessError(_ description: String)
    case urlSessionFailed(_ error: URLError)
    case timeOut
    case noInternet
    case decodingError(_ description: String)
    case error5xx(_ code: Int)
    case unknownError
}

protocol Request {
    var path: String { get }
    var fullPath: String? { get }
    var method: RequestMethod { get }
    var contentType: String { get }
    var body: [String: Any]? { get }
    var bodyData: Data? { get }
    var queryParams: [String: Any]? { get }
    var headers: [String: String]? { get }
    func createCommonHeaders(shouldHaveAuthorization: Bool) -> [String: String]?
}

extension Request {
    var method: RequestMethod { return .get }
    var contentType: String { return "application/json" }
    var fullPath: String? { return nil }
    var queryParams: [String: Any]? { return nil }
    var body: [String: Any]? { return nil }
    var bodyData: Data? { return nil }
    
    var headers: [String: String]? { return createCommonHeaders(shouldHaveAuthorization: true) }
    
    func createCommonHeaders(shouldHaveAuthorization: Bool) -> [String: String]? {
        if shouldHaveAuthorization {
            return [
                "Content-Type": "application/json",
                "Accept-Language": "en"
            ]
        } else {
            return [
                "Content-Type": "application/json",
                "Accept-Language": "en"
            ]
        }
    }
    
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    private func constructUrl(baseURL: String) -> URL? {
        guard fullPath == nil else {
            return URL(string: fullPath!)
        }
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        urlComponents.queryItems = addQueryItems(queryParams: queryParams)
        guard let finalURL = urlComponents.url else { return nil }
        return finalURL
    }
    
    func addQueryItems(queryParams: [String: Any]?) -> [URLQueryItem]? {
        guard let queryParams = queryParams else {
            return nil
        }
        return queryParams.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
    
    func asURLRequest(baseURL: String) -> URLRequest? {
        guard let finalURL = constructUrl(baseURL: baseURL) else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = bodyData ?? requestBodyFrom(params: body)
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 30
        return request
    }
}

struct NetworkRequest {
    static let token = "AIzaSyCXLMcg65KBb85-HSoROESlYhuuezxoYyk"
    static let clientId = "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" 
}
