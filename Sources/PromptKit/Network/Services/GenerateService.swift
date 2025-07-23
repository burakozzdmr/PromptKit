//
//  GenerateService.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

protocol GenerateServiceProtocol {
    func fetchTextMessage(
        rules: String,
        prompt: String,
        completion: @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    )
    func fetchImageAnalyze(
        rules: String,
        imageData: Data,
        completion: @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
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
        rules: String,
        prompt: String,
        completion: @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    ) {
        let request = Endpoint.prepareRequestURL(.textGeneratorGPT(rules, prompt))
        
        switch request {
        case .success(let textRequest):
            networkManager.sendRequest(
                request: textRequest,
                T: GPTAnalyzeResponseModel.self,
                completion: completion
            )
        case .failure(let errorType):
            print(errorType.errorMessage)
        }
    }
    
    func fetchImageAnalyze(
        rules: String,
        imageData: Data,
        completion: @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    ) {
        let imageDataBase64 = imageData.base64EncodedString()
        let request = Endpoint.prepareRequestURL(.imageAnalyzerGPT(rules, imageDataBase64))
        
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
