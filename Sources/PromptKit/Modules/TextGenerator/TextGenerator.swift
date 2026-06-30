//
//  TextGenerator.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025
//

import Combine
import Foundation

// MARK: - TextGenerator

public class TextGenerator {
    private let promptRules: String?
    private let prompt: String
    private let apiKey: String
    private let generateType: TextGenerateType
    private let textGenerateService: TextGenerateServiceProtocol

    public init(
        promptRules: String? = nil,
        prompt: String,
        apiKey: String,
        generateType: TextGenerateType
    ) {
        self.promptRules = promptRules
        self.prompt = prompt
        self.apiKey = apiKey
        self.generateType = generateType
        self.textGenerateService = TextGenerateService()
    }

    init(
        promptRules: String? = nil,
        prompt: String,
        apiKey: String,
        generateType: TextGenerateType,
        textGenerateService: TextGenerateServiceProtocol
    ) {
        self.promptRules = promptRules
        self.prompt = prompt
        self.apiKey = apiKey
        self.generateType = generateType
        self.textGenerateService = textGenerateService
    }
}

// MARK: - Public Methods

public extension TextGenerator {
    func fetchGeneratedText(completion: @escaping (Result<String, NetworkError>) -> Void) {
        textGenerateService.fetchTextMessage(
            rules: promptRules,
            prompt: prompt,
            apiKey: apiKey,
            generateType: generateType,
            completion: completion
        )
    }

    func fetchGeneratedTextPublisher() -> AnyPublisher<String, NetworkError> {
        textGenerateService.fetchTextMessagePublisher(
            rules: promptRules,
            prompt: prompt,
            apiKey: apiKey,
            generateType: generateType
        )
    }
}
