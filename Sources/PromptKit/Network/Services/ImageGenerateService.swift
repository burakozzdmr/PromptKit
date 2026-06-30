//
//  ImageGenerateService.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Combine
import Foundation

// MARK: - ImageGenerateServiceProtocol

protocol ImageGenerateServiceProtocol {
    func fetchImageAnalyze(
        rules: String,
        imageData: Data,
        apiKey: String,
        analyzeType: ImageAnalyzeType,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )

    func fetchImageAnalyzePublisher(
        rules: String,
        imageData: Data,
        apiKey: String,
        analyzeType: ImageAnalyzeType
    ) -> AnyPublisher<String, NetworkError>

    func fetchGeneratedImage(
        prompt: String,
        apiKey: String,
        generateType: ImageGenerateType,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    )

    func fetchGeneratedImagePublisher(
        prompt: String,
        apiKey: String,
        generateType: ImageGenerateType
    ) -> AnyPublisher<Data, NetworkError>
}

// MARK: - ImageGenerateService

class ImageGenerateService {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager(session: .init(configuration: .default))) {
        self.networkManager = networkManager
    }
}

// MARK: - ImageGenerateServiceProtocol Methods

extension ImageGenerateService: ImageGenerateServiceProtocol {
    func fetchImageAnalyze(
        rules: String,
        imageData: Data,
        apiKey: String,
        analyzeType: ImageAnalyzeType,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        switch analyzeType {
        case .gpt:
            send(.imageAnalyzerGPT(promptRules: rules, imageData: imageData, apiKey: apiKey), as: GPTAnalyzeResponseModel.self) { result in
                completion(result.map { $0.output.first?.content?.first?.text ?? "" })
            }
        case .gemini:
            send(.imageAnalyzerGemini(promptRules: rules, imageData: imageData, apiKey: apiKey), as: GeminiTextGenerateModel.self) { result in
                completion(result.map { $0.candidates.first?.content.parts.first?.text ?? "" })
            }
        case .claude:
            send(.imageAnalyzerClaude(promptRules: rules, imageData: imageData, apiKey: apiKey), as: ClaudeGenerateModel.self) { result in
                completion(result.map { $0.content.first?.text ?? "" })
            }
        }
    }

    func fetchImageAnalyzePublisher(
        rules: String,
        imageData: Data,
        apiKey: String,
        analyzeType: ImageAnalyzeType
    ) -> AnyPublisher<String, NetworkError> {
        switch analyzeType {
        case .gpt:
            return sendPublisher(.imageAnalyzerGPT(promptRules: rules, imageData: imageData, apiKey: apiKey), as: GPTAnalyzeResponseModel.self)
                .map { $0.output.first?.content?.first?.text ?? "" }
                .eraseToAnyPublisher()
        case .gemini:
            return sendPublisher(.imageAnalyzerGemini(promptRules: rules, imageData: imageData, apiKey: apiKey), as: GeminiTextGenerateModel.self)
                .map { $0.candidates.first?.content.parts.first?.text ?? "" }
                .eraseToAnyPublisher()
        case .claude:
            return sendPublisher(.imageAnalyzerClaude(promptRules: rules, imageData: imageData, apiKey: apiKey), as: ClaudeGenerateModel.self)
                .map { $0.content.first?.text ?? "" }
                .eraseToAnyPublisher()
        }
    }

    func fetchGeneratedImage(
        prompt: String,
        apiKey: String,
        generateType: ImageGenerateType,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        switch generateType {
        case .gpt:
            send(.imageGeneratorGPT(prompt: prompt, apiKey: apiKey), as: GPTImageGenerateResponseModel.self) { result in
                switch result {
                case .success(let response):
                    guard
                        let b64String = response.data.first?.b64_json,
                        let imageData = Data(base64Encoded: b64String)
                    else {
                        return completion(.failure(.decodingFailedError))
                    }
                    completion(.success(imageData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .gemini:
            completion(.failure(.requestFailedError))
        }
    }

    func fetchGeneratedImagePublisher(
        prompt: String,
        apiKey: String,
        generateType: ImageGenerateType
    ) -> AnyPublisher<Data, NetworkError> {
        switch generateType {
        case .gpt:
            return sendPublisher(.imageGeneratorGPT(prompt: prompt, apiKey: apiKey), as: GPTImageGenerateResponseModel.self)
                .tryMap { response -> Data in
                    guard
                        let b64String = response.data.first?.b64_json,
                        let imageData = Data(base64Encoded: b64String)
                    else {
                        throw NetworkError.decodingFailedError
                    }
                    return imageData
                }
                .mapError { ($0 as? NetworkError) ?? .requestFailedError }
                .eraseToAnyPublisher()
        case .gemini:
            return Fail(error: .requestFailedError).eraseToAnyPublisher()
        }
    }
}

// MARK: - Private Helpers

private extension ImageGenerateService {
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
