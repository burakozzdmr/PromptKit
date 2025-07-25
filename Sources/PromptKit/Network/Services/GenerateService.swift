//
//  GenerateService.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

protocol GenerateServiceProtocol {
    func fetchTextMessage(
        rules: String?,
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    )
    func fetchImageAnalyze(
        rules: String,
        imageData: Data,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    )
}

class GenerateService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManager = .init()) {
        self.networkManager = networkManager
    }
}

extension GenerateService: GenerateServiceProtocol {
    func fetchTextMessage(
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
    
    func fetchImageAnalyze(
        rules: String,
        imageData: Data,
        generateType: TextGenerateType,
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
                print(errorType.errorMessage)
            }
        }
    }
}
