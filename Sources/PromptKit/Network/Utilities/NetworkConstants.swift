//
//  NetworkConstants.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

public struct NetworkConstants {
    public static let authorizationHeaderKey = "Authorization"
    public static let contentTypeHeaderKey = "Content-Type"
    public static let jsonContentType = "application/json"
    public static let apiKeyPrefix = "Bearer"

    struct GPTConstants {
        static let baseURL = "https://api.openai.com/v1/"
        static let responsesPath = "responses"
        static let imageGeneratePath = "images/generations"
        static let userRoleName = "user"
    }

    struct GeminiConstants {
        static let baseURL = "https://generativelanguage.googleapis.com/v1/models/"
        static let textGeneratePath = "gemini-2.0-flash-lite:generateContent"
    }

    struct ClaudeConstants {
        static let baseURL = "https://api.anthropic.com/v1"
        static let messagesPath = "/messages"
        static let apiKeyHeaderKey = "x-api-key"
        static let apiVersionHeaderKey = "anthropic-version"
        static let apiVersionValue = "2023-06-01"
        static let userRoleName = "user"
    }
}
