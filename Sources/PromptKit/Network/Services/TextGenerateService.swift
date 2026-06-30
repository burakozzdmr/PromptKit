//
//  TextGenerateService.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Combine
import Foundation

// MARK: - TextGenerateServiceProtocol

protocol TextGenerateServiceProtocol {
    func fetchTextMessage(
        rules: String?,
        prompt: String,
        apiKey: String,
        generateType: TextGenerateType,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )

    func fetchTextMessagePublisher(
        rules: String?,
        prompt: String,
        apiKey: String,
        generateType: TextGenerateType
    ) -> AnyPublisher<String, NetworkError>
}

// MARK: - TextGenerateService

class TextGenerateService {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager(session: .init(configuration: .default))) {
        self.networkManager = networkManager
    }
}

// MARK: - TextGenerateServiceProtocol Methods

extension TextGenerateService: TextGenerateServiceProtocol {
    func fetchTextMessage(
        rules: String?,
        prompt: String,
        apiKey: String,
        generateType: TextGenerateType,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        switch generateType {
        case .gpt:
            send(.textGeneratorGPT(promptRules: rules, prompt: prompt, apiKey: apiKey), as: GPTAnalyzeResponseModel.self) { result in
                completion(result.map { $0.output.first?.content?.first?.text ?? "" })
            }
        case .gemini:
            send(.textGeneratorGemini(prompt: prompt, apiKey: apiKey), as: GeminiTextGenerateModel.self) { result in
                completion(result.map { $0.candidates.first?.content.parts.first?.text ?? "" })
            }
        case .claude:
            send(.textGeneratorClaude(promptRules: rules, prompt: prompt, apiKey: apiKey), as: ClaudeGenerateModel.self) { result in
                completion(result.map { $0.content.first?.text ?? "" })
            }
        }
    }

    func fetchTextMessagePublisher(
        rules: String?,
        prompt: String,
        apiKey: String,
        generateType: TextGenerateType
    ) -> AnyPublisher<String, NetworkError> {
        switch generateType {
        case .gpt:
            return sendPublisher(.textGeneratorGPT(promptRules: rules, prompt: prompt, apiKey: apiKey), as: GPTAnalyzeResponseModel.self)
                .map { $0.output.first?.content?.first?.text ?? "" }
                .eraseToAnyPublisher()
        case .gemini:
            return sendPublisher(.textGeneratorGemini(prompt: prompt, apiKey: apiKey), as: GeminiTextGenerateModel.self)
                .map { $0.candidates.first?.content.parts.first?.text ?? "" }
                .eraseToAnyPublisher()
        case .claude:
            return sendPublisher(.textGeneratorClaude(promptRules: rules, prompt: prompt, apiKey: apiKey), as: ClaudeGenerateModel.self)
                .map { $0.content.first?.text ?? "" }
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Private Helpers

private extension TextGenerateService {
    func send<T: Codable & Sendable>(
        _ endpoint: EndpointType,
        as type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        switch EndpointType.prepareRequestURL(endpoint) {
        case .success(let request):
            networkManager.sendRequest(request: request, T: type, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func sendPublisher<T: Codable>(
        _ endpoint: EndpointType,
        as type: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        switch EndpointType.prepareRequestURL(endpoint) {
        case .success(let request):
            return networkManager.sendRequestPublisher(request: request, T: type)
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
