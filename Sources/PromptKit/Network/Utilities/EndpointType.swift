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
    static func prepareRequestURL(_ endpoint: Self) -> Result<URLRequest, NetworkError>
}

enum EndpointType {
    case textGeneratorGPT(promptRules: String?, prompt: String, apiKey: String)
    case imageAnalyzerGPT(promptRules: String?, imageData: String, apiKey: String)
}

extension EndpointType: EndpointProtocol {
    var baseURL: String {
        return NetworkConstants.gptBaseURL
    }
    
    var path: String {
        return NetworkConstants.completionsPath
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
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestModel = GPTAnalyzeRequestModel(
                model: "gpt-3.5-turbo",
                messages: [
                    AnalyzeModel(role: "system", content: rules),
                    AnalyzeModel(role: "user", content: prompt)
                ]
            )
            request.httpBody = try? JSONEncoder().encode(requestModel)
            return .success(request)
            
        case .imageAnalyzerGPT(let rules, let imageData, let apiKey):
            var request: URLRequest = .init(url: requestURL)
            request.httpMethod = endpoint.method.rawValue
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestModel = GPTAnalyzeRequestModel(
                model: "gpt-3.5-turbo",
                messages: [
                    AnalyzeModel(role: "system", content: rules),
                    AnalyzeModel(role: "user", content: imageData)
                ]
            )
            request.httpBody = try? JSONEncoder().encode(requestModel)
            return .success(request)
        }
    }
}
