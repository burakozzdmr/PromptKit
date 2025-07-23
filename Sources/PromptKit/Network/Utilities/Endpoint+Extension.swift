//
//  Endpoint+Extension.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    static func prepareRequestURL(_ endpoint: Self) -> Result<URLRequest, NetworkError>
}

enum Endpoint {
    case textGeneratorGPT(String, String, String)
    case imageAnalyzerGPT(String, String, String)
}

extension Endpoint: EndpointProtocol {
    var baseURL: String {
        return NetworkConstants.gptBaseURL
    }
    
    var path: String {
        return NetworkConstants.completionsPath
    }
    
    var method: HTTPMethod {
        return .POST
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": "Bearer \("API_KEY")",
            "Content-Type": "application/json"
        ]
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    static func prepareRequestURL(_ endpoint: Endpoint) -> Result<URLRequest, NetworkError> {
        guard let urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path),
              let requestURL = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request: URLRequest = .init(url: requestURL)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        switch endpoint {
        case .textGeneratorGPT(let rules, let prompt, let apiKey):
            let requestModel = GPTTextRequestModel(
                model: "gpt-3.5-turbo",
                messages: [
                    TextModel(role: "system", content: rules),
                    TextModel(role: "user", content: prompt)
                ]
            )
            request.httpBody = try? JSONEncoder().encode(requestModel)
            return .success(request)
        case .imageAnalyzerGPT(let rules, let prompt, let apiKey):
            let requestModel = GPTTextRequestModel(
                model: "gpt-3.5-turbo",
                messages: [
                    TextModel(role: "system", content: rules),
                    TextModel(role: "user", content: prompt)
                ]
            )
            request.httpBody = try? JSONEncoder().encode(requestModel)
            return .success(request)
        }
    }
}
