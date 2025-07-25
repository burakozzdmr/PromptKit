//
//  ImageAnalyzer.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

internal class ImageAnalyzer {
    private let promptRules: String
    private let imageData: Data
    private let apiKey: String
    private let generateType: TextGenerateType
    private let generateService: GenerateServiceProtocol
    
    init(
        promptRules: String,
        imageData: Data,
        apiKey: String,
        generateType: TextGenerateType,
        generateService: GenerateService = .init()
    ) {
        self.promptRules = promptRules
        self.imageData = imageData
        self.apiKey = apiKey
        self.generateType = generateType
        self.generateService = generateService
    }
    
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
    
    func fetchImageAnalyzeData(completion: @Sendable @escaping (Result<String, NetworkError>) -> Void) {
        prepareImageAnalyzerData { imageAnalyzeResult in
            completion(imageAnalyzeResult)
        }
    }
}
