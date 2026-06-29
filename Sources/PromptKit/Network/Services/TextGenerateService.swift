//
//  TextGenerateService.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

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
        
    }
    
    func fetchTextMessageForGemini(
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @escaping @Sendable (Result<GeminiTextGenerateModel, NetworkError>) -> Void
    ) {
        
    }
}
