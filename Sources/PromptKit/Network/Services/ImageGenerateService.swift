//
//  ImageGenerateService.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Foundation

// MARK: - ImageGenerateServiceProtocol

protocol ImageGenerateServiceProtocol {
    func fetchImageAnalyzeForGemini(
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GeminiImageGenerateModel, NetworkError>) -> Void
    )
    
    func fetchGeneratedImageForGpt(
        prompt: String,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<Data, NetworkError>) -> Void
    )
    
    func fetchImageAnalyzeForGpt(
        rules: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @Sendable @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    )
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
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @escaping @Sendable (Result<GeminiImageGenerateModel, NetworkError>) -> Void
    ) {
            
    }
    
    func fetchGeneratedImageForGpt(
        prompt: String,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    ) {
        
    }
    
    func fetchImageAnalyzeForGpt(
        rules: String,
        imageData: Data,
        generateType: ImageGenerateType,
        apiKey: String,
        completion: @escaping @Sendable (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    ) {
        
    }
}
