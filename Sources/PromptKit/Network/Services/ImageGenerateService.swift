//
//  ImageGenerateService.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Combine
import Foundation

// MARK: - ImageGenerateServiceProtocol

protocol ImageGenerateServiceProtocol {
    func fetchImageAnalyzeForGemini(
        prompt: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @escaping (Result<GeminiImageGenerateModel, NetworkError>) -> Void
    )
    
    func fetchGeneratedImageForGpt(
        prompt: String,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    )
    
    func fetchImageAnalyzeForGpt(
        rules: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    )
    
    func fetchImageAnalyzeForGeminiPublisher(
        prompt: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String
    ) -> AnyPublisher<GeminiImageGenerateModel, NetworkError>
    
    func fetchGeneratedImageForGPTPublisher(
        prompt: String,
        generateType: ImageGenerateType,
        apiKey: String
    ) -> AnyPublisher<Data, NetworkError>
    
    func fetchImageAnalyzeForGPTPublisher(
        rules: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String
    ) -> AnyPublisher<GPTAnalyzeResponseModel, NetworkError>
}

// MARK: - ImageGenerateService

class ImageGenerateService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(session: .init(configuration: .default))) {
        self.networkManager = networkManager
    }
}

// MARK: - ImageGenerateServiceProtocol Methods

extension ImageGenerateService: ImageGenerateServiceProtocol {
    
    func fetchImageAnalyzeForGemini(
        prompt: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @escaping (Result<GeminiImageGenerateModel, NetworkError>) -> Void
    ) {
        let request = EndpointType.prepareRequestURL(.imageAnalyzerGemini(prompt: prompt, imageData: imageData, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            networkManager.sendRequest(request: successRequest, T: GeminiImageGenerateModel.self, completion: completion)
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    func fetchGeneratedImageForGpt(
        prompt: String,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        let request = EndpointType.prepareRequestURL(.imageGeneratorGPT(prompt: prompt, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            networkManager.sendRequest(request: successRequest, T: Data.self, completion: completion)
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    func fetchImageAnalyzeForGpt(
        rules: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    ) {
        let request = EndpointType.prepareRequestURL(.imageAnalyzerGPT(promptRules: rules, imageData: imageData, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            return networkManager
                .sendRequest(request: successRequest, T: GPTAnalyzeResponseModel.self, completion: completion)
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    func fetchImageAnalyzeForGeminiPublisher(
        prompt: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String
    ) -> AnyPublisher<GeminiImageGenerateModel, NetworkError> {
        let request = EndpointType.prepareRequestURL(.imageAnalyzerGemini(prompt: prompt, imageData: imageData, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            return networkManager
                .sendRequestPublisher(request: successRequest, T: GeminiImageGenerateModel.self)
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchGeneratedImageForGPTPublisher(
        prompt: String,
        generateType: ImageGenerateType,
        apiKey: String
    ) -> AnyPublisher<Data, NetworkError> {
        let request = EndpointType.prepareRequestURL(.imageGeneratorGPT(prompt: prompt, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            return networkManager
                .sendRequestPublisher(request: successRequest, T: Data.self)
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchImageAnalyzeForGPTPublisher(
        rules: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String
    ) -> AnyPublisher<GPTAnalyzeResponseModel, NetworkError> {
        let request = EndpointType.prepareRequestURL(.imageAnalyzerGPT(promptRules: rules, imageData: imageData, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            return networkManager
                .sendRequestPublisher(request: successRequest, T: GPTAnalyzeResponseModel.self)
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
