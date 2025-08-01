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
    public static let apiKeyPrefix = "Bearer "
    
    struct GPTConstants {
        public static let baseURL = "https://api.openai.com/v1/"
        public static let completionsPath = "chat/completions"
        public static let imageGeneratePath = "images/generations"
        public static let systemRoleName = "system"
        public static let userRoleName = "user"
    }
    
    struct GeminiConstants {
        public static let baseURL = "https://generativelanguage.googleapis.com/v1/models/"
        public static let geminiPath = "gemini-2.0-flash-lite:generateContent"
    }
}
