//
//  ImageGenerator.swift
//  PromptKit
//
//  Created by Burak Özdemir on 1.08.2025.
//

import Foundation

public class ImageGenerator {
    private let prompt: String
    private let generateType: ImageGenerateType
    private let apiKey: String
    private let imageGenerateService: ImageGenerateServiceProtocol
    
    init(
        prompt: String,
        generateType: ImageGenerateType,
        apiKey: String,
        imageGenerateService: ImageGenerateServiceProtocol = ImageGenerateService()
    ) {
        self.prompt = prompt
        self.generateType = generateType
        self.apiKey = apiKey
        self.imageGenerateService = imageGenerateService
    }
}

// MARK: - Publics

public extension ImageGenerator {
    func fetchGeneratedImage(completion: @Sendable @escaping (Result<Data, NetworkError>) -> Void) {
        imageGenerateService.fetchGeneratedImageForGpt(prompt: prompt, generateType: generateType, apiKey: apiKey) { imageResult in
            switch imageResult {
            case .success(let imageData):
                completion(.success(imageData))
            case .failure(let errorType):
                completion(.failure(errorType))
            }
        }
    }
}
