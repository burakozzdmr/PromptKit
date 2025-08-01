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
    private let generateService: GenerateService = .init()
    
    public init(prompt: String, generateType: ImageGenerateType, apiKey: String) {
        self.prompt = prompt
        self.generateType = generateType
        self.apiKey = apiKey
    }
}

// MARK: - Publics

public extension ImageGenerator {
    func fetchGeneratedImage(completion: @Sendable @escaping (Result<Data, NetworkError>) -> Void) {
        generateService.fetchGeneratedImageForGpt(prompt: prompt, generateType: generateType, apiKey: apiKey) { imageResult in
            switch imageResult {
            case .success(let imageData):
                completion(.success(imageData))
            case .failure(let errorType):
                completion(.failure(errorType))
            }
        }
    }
}
