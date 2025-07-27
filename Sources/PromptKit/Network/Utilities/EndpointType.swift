//
//  Endpoint+Extension.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

public protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    static func prepareRequestURL(_ endpoint: Self) -> Result<URLRequest, NetworkError>
}

public enum EndpointType {
    case textGeneratorGPT(promptRules: String?, prompt: String, apiKey: String)
    case imageAnalyzerGPT(promptRules: String?, imageData: String, apiKey: String)
}

public extension EndpointType {
    var baseURL: String {
        return NetworkConstants.GPTConstants.baseURL
    }
    
    var path: String {
        return NetworkConstants.GPTConstants.completionsPath
    }
    
    var method: HTTPMethod {
        return .POST
    }
    
    static func prepareRequestURL(_ endpoint: EndpointType) -> Result<URLRequest, NetworkError> {
        guard let urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path),
              let requestURL = urlComponents.url else {
            return .failure(.invalidURL)
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
        }
    }
}
