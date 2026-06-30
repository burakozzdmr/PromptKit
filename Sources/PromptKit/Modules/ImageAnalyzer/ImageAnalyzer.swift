//
//  ImageAnalyzer.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Combine
import Foundation

// MARK: - ImageAnalyzer

public class ImageAnalyzer {
    private let promptRules: String
    private let imageData: Data
    private let apiKey: String
    private let analyzeType: ImageAnalyzeType
    private let imageGenerateService: ImageGenerateServiceProtocol

    public init(
        promptRules: String,
        imageData: Data,
        apiKey: String,
        analyzeType: ImageAnalyzeType
    ) {
        self.promptRules = promptRules
        self.imageData = imageData
        self.apiKey = apiKey
        self.analyzeType = analyzeType
        self.imageGenerateService = ImageGenerateService()
    }

    init(
        promptRules: String,
        imageData: Data,
        apiKey: String,
        analyzeType: ImageAnalyzeType,
        imageGenerateService: ImageGenerateServiceProtocol
    ) {
        self.promptRules = promptRules
        self.imageData = imageData
        self.apiKey = apiKey
        self.analyzeType = analyzeType
        self.imageGenerateService = imageGenerateService
    }
}

// MARK: - Public Methods

public extension ImageAnalyzer {
    func fetchImageAnalyzeData(completion: @escaping (Result<String, NetworkError>) -> Void) {
        imageGenerateService.fetchImageAnalyze(
            rules: promptRules,
            imageData: imageData,
            apiKey: apiKey,
            analyzeType: analyzeType,
            completion: completion
        )
    }

    func fetchImageAnalyzeDataPublisher() -> AnyPublisher<String, NetworkError> {
        imageGenerateService.fetchImageAnalyzePublisher(
            rules: promptRules,
            imageData: imageData,
            apiKey: apiKey,
            analyzeType: analyzeType
        )
    }
}
