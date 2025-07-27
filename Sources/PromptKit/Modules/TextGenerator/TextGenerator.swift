//
//  TextGenerator.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025
//
 
import Foundation

// MARK: - TextGenerator

public class TextGenerator {
    private let promptRules: String?
    private let prompt: String
    private let apiKey: String
    private let generateType: TextGenerateType
    private let generateService: GenerateServiceProtocol
    
    public init(
        promptRules: String? = "",
        prompt: String,
        apiKey: String,
        generateType: TextGenerateType,
        generateService: GenerateServiceProtocol
    ) {
        self.promptRules = promptRules
        self.prompt = prompt
        self.apiKey = apiKey
        self.generateType = generateType
        self.generateService = generateService
    }
}

// MARK: - Private Methods

private extension TextGenerator {
    private func prepareGeneratedData(completion: @Sendable @escaping (Result<String, NetworkError>) -> Void) {
        if generateType == .textGeneratorGPT {
            generateService.fetchTextMessage(rules: promptRules, prompt: prompt, generateType: generateType, apiKey: apiKey) { generatedData in
                switch generatedData {
                case .success(let generatedText):
                    completion(.success(generatedText.choices.first?.message.content ?? ""))
                case .failure(let errorType):
                    completion(.failure(errorType))
                }
            }
        }
    }
}

// MARK: - Public Methods

public extension TextGenerator {
    func fetchGeneratedText(completion: @Sendable @escaping (Result<String, NetworkError>) -> Void) {
        prepareGeneratedData { generatedTextResult in
            completion(generatedTextResult)
        }
    }
}
