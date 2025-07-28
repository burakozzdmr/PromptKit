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
    private let generateService: GenerateServiceProtocol
    
    public init(
        promptRules: String,
        imageData: Data,
        apiKey: String,
        generateType: ImageGenerateType,
        generateService: GenerateService = .init()
    ) {
        self.promptRules = promptRules
        self.imageData = imageData
        self.apiKey = apiKey
        self.generateType = generateType
        self.generateService = generateService
    }
}

// MARK: - Private Methods

private extension ImageAnalyzer {
    private func prepareImageAnalyzerData(completion: @Sendable @escaping (Result<String, NetworkError>) -> Void) {
        generateService.fetchImageAnalyze(
            rules: promptRules,
            imageData: imageData,
            generateType: generateType,
            apiKey: apiKey
        ) { imageAnalyzeData in
            switch imageAnalyzeData {
            case .success(let analyzeData):
                completion(.success(analyzeData.choices.first?.message.content ?? ""))
            case .failure(let errorType):
                completion(.failure(errorType))
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
