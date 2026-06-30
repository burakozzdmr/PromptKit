//
//  EndpointType.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

// MARK: - Enums

public enum EndpointType {
    case textGeneratorGPT(promptRules: String?, prompt: String, apiKey: String)
    case imageAnalyzerGPT(promptRules: String?, imageData: Data, apiKey: String)
    case imageGeneratorGPT(prompt: String, apiKey: String)
    case textGeneratorGemini(prompt: String, apiKey: String)
    case imageAnalyzerGemini(promptRules: String, imageData: Data, apiKey: String)
    case textGeneratorClaude(promptRules: String?, prompt: String, apiKey: String)
    case imageAnalyzerClaude(promptRules: String?, imageData: Data, apiKey: String)
}

// MARK: - Extensions

public extension EndpointType {
    var baseURL: String {
        switch self {
        case .textGeneratorGPT, .imageAnalyzerGPT, .imageGeneratorGPT:
            return NetworkConstants.GPTConstants.baseURL
        case .textGeneratorGemini, .imageAnalyzerGemini:
            return NetworkConstants.GeminiConstants.baseURL
        case .textGeneratorClaude, .imageAnalyzerClaude:
            return NetworkConstants.ClaudeConstants.baseURL
        }
    }

    var path: String {
        switch self {
        case .textGeneratorGPT, .imageAnalyzerGPT:
            return NetworkConstants.GPTConstants.responsesPath
        case .imageGeneratorGPT:
            return NetworkConstants.GPTConstants.imageGeneratePath
        case .textGeneratorGemini, .imageAnalyzerGemini:
            return NetworkConstants.GeminiConstants.textGeneratePath
        case .textGeneratorClaude, .imageAnalyzerClaude:
            return NetworkConstants.ClaudeConstants.messagesPath
        }
    }

    var method: HTTPMethod { .POST }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .textGeneratorGemini(_, let apiKey),
             .imageAnalyzerGemini(_, _, let apiKey):
            return [URLQueryItem(name: "key", value: apiKey)]
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        return [NetworkConstants.contentTypeHeaderKey: NetworkConstants.jsonContentType]
    }

    static func prepareRequestURL(_ endpoint: EndpointType) -> Result<URLRequest, NetworkError> {
        guard var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        urlComponents.queryItems = endpoint.queryItems
        guard let requestURL = urlComponents.url else {
            return .failure(.requestFailedError)
        }

        switch endpoint {
        case .textGeneratorGPT(let rules, let prompt, let apiKey):
            let body = GPTTextGenerateRequestModel(
                model: "gpt-4o-mini",
                instructions: rules ?? "",
                input: prompt
            )
            return .success(makeRequest(url: requestURL, auth: .bearer(apiKey: apiKey), body: body))

        case .imageAnalyzerGPT(let rules, let imageData, let apiKey):
            let base64Image = "data:image/jpeg;base64,\(imageData.base64EncodedString())"
            let body = GPTImageAnalyzeRequestModel(
                model: "gpt-4o",
                input: [
                    GPTImageAnalyzeRequestModel.ImageAnalyzeModel(
                        role: NetworkConstants.GPTConstants.userRoleName,
                        content: [
                            GPTImageAnalyzeRequestModel.ImageAnalyzeModel.AnalyzeModel(
                                type: "input_text", text: rules, image_url: nil
                            ),
                            GPTImageAnalyzeRequestModel.ImageAnalyzeModel.AnalyzeModel(
                                type: "input_image", text: nil, image_url: base64Image
                            )
                        ]
                    )
                ]
            )
            return .success(makeRequest(url: requestURL, auth: .bearer(apiKey: apiKey), body: body))

        case .imageGeneratorGPT(let prompt, let apiKey):
            let body = GPTImageGenerateRequestModel(
                model: "gpt-image-1",
                prompt: prompt,
                n: 1,
                size: "1024x1024"
            )
            return .success(makeRequest(url: requestURL, auth: .bearer(apiKey: apiKey), body: body))

        case .textGeneratorGemini(let prompt, _):
            let body = GeminiTextGenerateRequestModel(
                contents: [
                    GeminiTextGenerateRequestModel.Content(
                        parts: [GeminiTextGenerateRequestModel.Content.Part(text: prompt, inlineData: nil)]
                    )
                ]
            )
            return .success(makeRequest(url: requestURL, auth: .none, body: body))

        case .imageAnalyzerGemini(let promptRules, let imageData, _):
            let body = GeminiTextGenerateRequestModel(
                contents: [
                    GeminiTextGenerateRequestModel.Content(
                        parts: [
                            GeminiTextGenerateRequestModel.Content.Part(text: promptRules, inlineData: nil),
                            GeminiTextGenerateRequestModel.Content.Part(
                                text: nil,
                                inlineData: GeminiTextGenerateRequestModel.Content.Part.InlineData(
                                    mimeType: "image/jpeg",
                                    data: imageData.base64EncodedString()
                                )
                            )
                        ]
                    )
                ]
            )
            return .success(makeRequest(url: requestURL, auth: .none, body: body))

        case .textGeneratorClaude(let rules, let prompt, let apiKey):
            let userContent = rules.map { "\($0)\n\(prompt)" } ?? prompt
            let body = ClaudeTextGenerateRequestModel(
                model: "claude-sonnet-4-6",
                max_tokens: 1024,
                messages: [
                    ClaudeTextGenerateRequestModel.ClaudeMessage(
                        role: NetworkConstants.ClaudeConstants.userRoleName,
                        content: userContent
                    )
                ]
            )
            return .success(makeRequest(url: requestURL, auth: .claude(apiKey: apiKey), body: body))

        case .imageAnalyzerClaude(let rules, let imageData, let apiKey):
            var messageContent: [ClaudeImageAnalyzeRequestModel.ClaudeMessage.Content] = [
                ClaudeImageAnalyzeRequestModel.ClaudeMessage.Content(
                    type: "image",
                    source: ClaudeImageAnalyzeRequestModel.ClaudeMessage.Content.Source(
                        type: "base64",
                        media_type: "image/jpeg",
                        data: imageData.base64EncodedString()
                    ),
                    text: nil
                )
            ]
            if let rules {
                messageContent.append(
                    ClaudeImageAnalyzeRequestModel.ClaudeMessage.Content(
                        type: "text", source: nil, text: rules
                    )
                )
            }
            let body = ClaudeImageAnalyzeRequestModel(
                model: "claude-opus-4-8",
                max_tokens: 1024,
                messages: [
                    ClaudeImageAnalyzeRequestModel.ClaudeMessage(
                        role: NetworkConstants.ClaudeConstants.userRoleName,
                        content: messageContent
                    )
                ]
            )
            return .success(makeRequest(url: requestURL, auth: .claude(apiKey: apiKey), body: body))
        }
    }
}

// MARK: - Private Helpers

private extension EndpointType {
    enum AuthHeader {
        case bearer(apiKey: String)
        case claude(apiKey: String)
        case none
    }

    static func makeRequest<Body: Encodable>(
        url: URL,
        auth: AuthHeader,
        body: Body
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue(
            NetworkConstants.jsonContentType,
            forHTTPHeaderField: NetworkConstants.contentTypeHeaderKey
        )
        switch auth {
        case .bearer(let apiKey):
            request.setValue(
                "\(NetworkConstants.apiKeyPrefix) \(apiKey)",
                forHTTPHeaderField: NetworkConstants.authorizationHeaderKey
            )
        case .claude(let apiKey):
            request.setValue(apiKey, forHTTPHeaderField: NetworkConstants.ClaudeConstants.apiKeyHeaderKey)
            request.setValue(
                NetworkConstants.ClaudeConstants.apiVersionValue,
                forHTTPHeaderField: NetworkConstants.ClaudeConstants.apiVersionHeaderKey
            )
        case .none:
            break
        }
        request.httpBody = try? JSONEncoder().encode(body)
        return request
    }
}
