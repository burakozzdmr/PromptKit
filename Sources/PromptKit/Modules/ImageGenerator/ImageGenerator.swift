//
//  ImageGenerator.swift
//  PromptKit
//
//  Created by Burak Özdemir on 1.08.2025.
//

import Combine
import Foundation

// MARK: - ImageGenerator

public class ImageGenerator {
    private let prompt: String
    private let apiKey: String
    private let generateType: ImageGenerateType
    private let imageGenerateService: ImageGenerateServiceProtocol

    public init(
        prompt: String,
        apiKey: String,
        generateType: ImageGenerateType
    ) {
        self.prompt = prompt
        self.apiKey = apiKey
        self.generateType = generateType
        self.imageGenerateService = ImageGenerateService()
    }

    init(
        prompt: String,
        apiKey: String,
        generateType: ImageGenerateType,
        imageGenerateService: ImageGenerateServiceProtocol
    ) {
        self.prompt = prompt
        self.apiKey = apiKey
        self.generateType = generateType
        self.imageGenerateService = imageGenerateService
    }
}

// MARK: - Public Methods

public extension ImageGenerator {
    func fetchGeneratedImage(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        imageGenerateService.fetchGeneratedImage(
            prompt: prompt,
            apiKey: apiKey,
            generateType: generateType,
            completion: completion
        )
    }

    func fetchGeneratedImagePublisher() -> AnyPublisher<Data, NetworkError> {
        imageGenerateService.fetchGeneratedImagePublisher(
            prompt: prompt,
            apiKey: apiKey,
            generateType: generateType
        )
    }
}
