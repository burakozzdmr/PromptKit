//
//  TextGenerateService.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Combine
import Foundation

// MARK: - TextGenerateServiceProtocol

protocol TextGenerateServiceProtocol {
    func fetchTextMessageForGpt(
        rules: String?,
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    )
    
    func fetchTextMessageForGemini(
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GeminiTextGenerateModel, NetworkError>) -> Void
    )
    
    func fetchTextMessageForGPTPublisher(
        rules: String?,
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String
    ) -> AnyPublisher<GPTAnalyzeResponseModel, NetworkError>
    
    func fetchTextMessageForGeminiPublisher(
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String
    ) -> AnyPublisher<GeminiTextGenerateModel, NetworkError>
}

// MARK: - TextGenerateService

class TextGenerateService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(session: .init(configuration: .default))) {
        self.networkManager = networkManager
    }
}

// MARK: - TextGenerateServiceProtocol Methods

extension TextGenerateService: TextGenerateServiceProtocol {
    
    func fetchTextMessageForGpt(
        rules: String?,
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @escaping @Sendable (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    ) {
        let request = EndpointType.prepareRequestURL(.textGeneratorGPT(promptRules: rules, prompt: prompt, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            networkManager.sendRequest(request: successRequest, T: GPTAnalyzeResponseModel.self, completion: completion)
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    func fetchTextMessageForGemini(
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @escaping @Sendable (Result<GeminiTextGenerateModel, NetworkError>) -> Void
    ) {
        let request = EndpointType.prepareRequestURL(.textGeneratorGemini(prompt: prompt, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            networkManager.sendRequest(request: successRequest, T: GeminiTextGenerateModel.self, completion: completion)
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    func fetchTextMessageForGPTPublisher(
        rules: String?,
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String
    ) -> AnyPublisher<GPTAnalyzeResponseModel, NetworkError> {
        let request = EndpointType.prepareRequestURL(.textGeneratorGPT(promptRules: rules, prompt: prompt, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            return networkManager
                .sendRequestPublisher(request: successRequest, T: GPTAnalyzeResponseModel.self)
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchTextMessageForGeminiPublisher(
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String
    ) -> AnyPublisher<GeminiTextGenerateModel, NetworkError> {
        let request = EndpointType.prepareRequestURL(.textGeneratorGemini(prompt: prompt, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            return networkManager
                .sendRequestPublisher(request: successRequest, T: GeminiTextGenerateModel.self)
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
