//
//  Endpoint+Extension.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

// MARK: - Protocols

public protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    static func prepareRequestURL(_ endpoint: Self) -> Result<URLRequest, NetworkError>
}

// MARK: - Enums

public enum EndpointType {
    case textGeneratorGPT(promptRules: String?, prompt: String, apiKey: String)
    case imageAnalyzerGPT(promptRules: String?, imageData: String, apiKey: String)
    case gemini(prompt: String, apiKey: String)
}

// MARK: - Extensions

public extension EndpointType {
    var baseURL: String {
        switch self {
        case .textGeneratorGPT, .imageAnalyzerGPT:
            return NetworkConstants.GPTConstants.baseURL
            
        case .gemini:
            return NetworkConstants.GeminiConstants.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .textGeneratorGPT, .imageAnalyzerGPT:
            return NetworkConstants.GPTConstants.completionsPath
            
        case .gemini:
            return NetworkConstants.GeminiConstants.geminiPath
        }
    }
    
    var method: HTTPMethod {
        return .POST
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .gemini(_, let apiKey):
            return [
                URLQueryItem(name: "key", value: "\(apiKey)")
            ]
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        return [NetworkConstants.jsonContentType: NetworkConstants.contentTypeHeaderKey]
    }
    
    static func prepareRequestURL(_ endpoint: EndpointType) -> Result<URLRequest, NetworkError> {
        guard var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }

        urlComponents.queryItems = endpoint.queryItems

        guard let requestURL = urlComponents.url else {
            return .failure(.requestFailedError)
        }
        
        switch endpoint {
        case .textGeneratorGPT(let rules, let prompt, let apiKey):
            var request: URLRequest = .init(url: requestURL)
            request.httpMethod = endpoint.method.rawValue
            request.setValue(
                "\(NetworkConstants.apiKeyPrefix) \(apiKey)",
                forHTTPHeaderField: NetworkConstants.authorizationHeaderKey
            )
            
            request.setValue(
                NetworkConstants.jsonContentType,
                forHTTPHeaderField: NetworkConstants.contentTypeHeaderKey
            )
            
            let requestModel = GPTAnalyzeRequestModel(
                model: "gpt-3.5-turbo",
                messages: [
                    GPTAnalyzeRequestModel.AnalyzeModel(role: NetworkConstants.GPTConstants.systemRoleName, content: rules),
                    GPTAnalyzeRequestModel.AnalyzeModel(role: NetworkConstants.GPTConstants.userRoleName, content: prompt)
                ]
            )
            request.httpBody = try? JSONEncoder().encode(requestModel)
            return .success(request)
            
        case .imageAnalyzerGPT(let rules, let imageData, let apiKey):
            var request: URLRequest = .init(url: requestURL)
            request.httpMethod = endpoint.method.rawValue
            request.setValue(
                "\(NetworkConstants.apiKeyPrefix) \(apiKey)",
                forHTTPHeaderField: NetworkConstants.authorizationHeaderKey
            )
            
            request.setValue(
                NetworkConstants.jsonContentType,
                forHTTPHeaderField: NetworkConstants.contentTypeHeaderKey
            )
            
            let requestModel = GPTAnalyzeRequestModel(
                model: "gpt-3.5-turbo",
                messages: [
                    GPTAnalyzeRequestModel.AnalyzeModel(role: NetworkConstants.GPTConstants.systemRoleName, content: rules),
                    GPTAnalyzeRequestModel.AnalyzeModel(role: NetworkConstants.GPTConstants.userRoleName, content: imageData)
                ]
            )
            request.httpBody = try? JSONEncoder().encode(requestModel)
            return .success(request)
        case .gemini(let prompt, _):
            var request: URLRequest = .init(url: requestURL)
            request.httpMethod = endpoint.method.rawValue
            request.allHTTPHeaderFields = endpoint.headers
            
            let requestBodyModel = GeminiRequestModel(
                contents: [GeminiRequestModel.Content(
                    parts: [
                        GeminiRequestModel.Content.Part(
                            text: prompt
                        )
                    ]
                )]
            )
            request.httpBody = try? JSONEncoder().encode(requestBodyModel)
            return .success(request)
        }
    }
}
