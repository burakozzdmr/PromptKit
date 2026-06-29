//
//  ImageAnalyzer.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

// MARK: - ImageAnalyzer

public class ImageAnalyzer {
    private let promptRules: String
    private let imageData: Data
    private let apiKey: String
    private let generateType: ImageGenerateType
    private let imageGenerateService: ImageGenerateServiceProtocol = ImageGenerateService()
    
    init(
        promptRules: String,
        imageData: Data,
        apiKey: String,
        generateType: ImageGenerateType,
        imageGenerateService: ImageGenerateServiceProtocol
    ) {
        self.promptRules = promptRules
        self.imageData = imageData
        self.apiKey = apiKey
        self.generateType = generateType
    }
}

// MARK: - Private Methods

private extension ImageAnalyzer {
    private func prepareImageAnalyzerData(completion: @Sendable @escaping (Result<String, NetworkError>) -> Void) {
        if generateType == .gpt {
            imageGenerateService.fetchImageAnalyzeForGpt(
                rules: promptRules,
                imageData: imageData,
                generateType: generateType,
                apiKey: apiKey
            ) { imageAnalyzeResult in
                switch imageAnalyzeResult {
                case .success(let analyzeData):
                    completion(.success(analyzeData.output.first?.content?.first?.text ?? ""))
                case .failure(let errorType):
                    completion(.failure(errorType))
                }
            }
        } else if generateType == .gemini {
            imageGenerateService.fetchImageAnalyzeForGemini(
                prompt: promptRules,
                imageData: imageData,
                generateType: generateType,
                apiKey: apiKey
            ) { imageAnalyzeResult in
                switch imageAnalyzeResult {
                case .success(let analyzeData):
                    completion(.success(analyzeData.candidates.first?.content.parts.first?.text ?? ""))
                case .failure(let errorType):
                    completion(.failure(errorType))
                }
            }
        }
    }
}

// MARK: - Public Methods

public extension ImageAnalyzer {
    func fetchImageAnalyzeData(completion: @Sendable @escaping (Result<String, NetworkError>) -> Void) {
        prepareImageAnalyzerData { imageAnalyzeResult in
            completion(imageAnalyzeResult)
        }
    }
}
