//
//  GenerateService.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

// MARK: - GenerateServiceProtocol

public protocol GenerateServiceProtocol {
    func fetchTextMessageForGpt(
        rules: String?,
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    )
    
    func fetchImageAnalyzeForGpt(
        rules: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    )
    
    func fetchTextMessageForGemini(
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GeminiResponseModel, NetworkError>) -> Void
    )
    
    func fetchImageAnalyzeForGemini(
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GeminiResponseModel, NetworkError>) -> Void
    )
    
    func fetchGeneratedImageForGpt(
        prompt: String,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<Data, NetworkError>) -> Void
    )
}

// MARK: - GenerateService

public class GenerateService: @unchecked Sendable {
    private let networkManager: NetworkManagerProtocol
    
    public init(networkManager: NetworkManager = .init()) {
        self.networkManager = networkManager
    }
}

// MARK: - Privates

private extension GenerateService {
    func fetchGeneratedImageURL(prompt: String, apiKey: String, completion: @Sendable @escaping (URLRequest) -> Void) {
        let request = EndpointType.prepareRequestURL(.imageGeneratorGPT(prompt: prompt, apiKey: apiKey))
        
        switch request {
        case .success(let successRequest):
            networkManager.sendRequest(
                request: successRequest,
                T: GPTImageGenerateResponseModel.self) { generatedImageModel in
                    switch generatedImageModel {
                    case .success(let generatedImageURL):
                        guard let imageURL = URL(string: generatedImageURL.data.first?.url ?? "") else { return }
                        
                        let imageRequest: URLRequest = .init(url: imageURL)
                        completion(imageRequest)
                    case .failure(let errorType):
                        print(errorType.errorMessage)
                    }
                }
            
        case .failure(let errorType):
            print(errorType.errorMessage)
        }
    }
}

// MARK: - Publics

extension GenerateService: GenerateServiceProtocol {
    public func fetchTextMessageForGpt(
        rules: String? = "",
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    ) {
        if generateType == .textGeneratorGPT {
            let request = EndpointType.prepareRequestURL(.textGeneratorGPT(promptRules: rules, prompt: prompt, apiKey: apiKey))
            
            switch request {
            case .success(let textRequest):
                networkManager.sendRequest(
                    request: textRequest,
                    T: GPTAnalyzeResponseModel.self,
                    completion: completion
                )
            case .failure(let errorType):
                completion(.failure(errorType))
            }
        }
    }
    
    public func fetchImageAnalyzeForGpt(
        rules: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    ) {
        if generateType == .imageAnalyzerGPT {
            let imageDataBase64 = imageData.base64EncodedString()
            let request = EndpointType.prepareRequestURL(.imageAnalyzerGPT(promptRules: rules, imageData: imageDataBase64, apiKey: apiKey))
            
            switch request {
            case .success(let imageRequest):
                networkManager.sendRequest(
                    request: imageRequest,
                    T: GPTAnalyzeResponseModel.self,
                    completion: completion
                )
            case .failure(let errorType):
                completion(.failure(errorType))
            }
        }
    }
    
    public func fetchTextMessageForGemini(
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (
            Result<GeminiResponseModel, NetworkError>
        ) -> Void
    ) {
        if generateType == .textGeneratorGemini {
            let request = EndpointType.prepareRequestURL(.textGeneratorGemini(prompt: prompt, apiKey: apiKey))
            
            switch request {
            case .success(let successRequest):
                networkManager.sendRequest(
                    request: successRequest,
                    T: GeminiResponseModel.self,
                    completion: completion
                )
            case .failure(let errorType):
                completion(.failure(errorType))
            }
        }
    }
    
    public func fetchImageAnalyzeForGemini(
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (
            Result<GeminiResponseModel, NetworkError>
        ) -> Void
    ) {
        if generateType == .imageAnalyzerGemini {
            let imageDataConvertedBase64 = imageData.base64EncodedString()
            
            let request = EndpointType.prepareRequestURL(.textGeneratorGemini(prompt: imageDataConvertedBase64, apiKey: apiKey))
            
            switch request {
            case .success(let successRequest):
                networkManager.sendRequest(
                    request: successRequest,
                    T: GeminiResponseModel.self,
                    completion: completion
                )
            case .failure(let errorType):
                completion(.failure(errorType))
            }
        }
    }
    
    public func fetchGeneratedImageForGpt(
        prompt: String,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<Data, NetworkError>) -> Void
    ) {
        fetchGeneratedImageURL(prompt: prompt, apiKey: apiKey) { imageRequest in
            self.networkManager.fetchImageData(
                request: imageRequest) { imageResult in
                    switch imageResult {
                    case .success(let imageData):
                        completion(.success(imageData))
                    case .failure(let errorType):
                        completion(.failure(errorType))
                }
            }
        }
    }
}
