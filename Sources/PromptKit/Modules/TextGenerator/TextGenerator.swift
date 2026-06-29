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
    private let textGenerateService: TextGenerateServiceProtocol
    
    init(
        promptRules: String? = "",
        prompt: String,
        apiKey: String,
        generateType: TextGenerateType,
        textGenerateService: TextGenerateServiceProtocol = TextGenerateService()
        
    ) {
        self.promptRules = promptRules
        self.prompt = prompt
        self.apiKey = apiKey
        self.generateType = generateType
        self.textGenerateService = textGenerateService
    }
}

// MARK: - Private Methods

private extension TextGenerator {
    private func prepareGeneratedData(completion: @escaping (Result<String, NetworkError>) -> Void) {
        if generateType == .gpt {
            textGenerateService.fetchTextMessageForGpt(rules: promptRules, prompt: prompt, generateType: generateType, apiKey: apiKey) { generatedData in
                switch generatedData {
                case .success(let generatedText):
                    completion(.success(generatedText.output.first?.content?.first?.text ?? ""))
                case .failure(let errorType):
                    completion(.failure(errorType))
                }
            }
        } else if generateType == .gemini {
            textGenerateService.fetchTextMessageForGemini(prompt: prompt, generateType: generateType, apiKey: apiKey) { generatedData in
                switch generatedData {
                case .success(let generatedText):
                    completion(.success(generatedText.candidates.first?.content.parts.first?.text ?? ""))
                case .failure(let errorType):
                    completion(.failure(errorType))
                }
            }
        }
    }
}

// MARK: - Public Methods

public extension TextGenerator {
    func fetchGeneratedText(completion: @escaping (Result<String, NetworkError>) -> Void) {
        prepareGeneratedData { generatedTextResult in
            completion(generatedTextResult)
        }
    }
}
