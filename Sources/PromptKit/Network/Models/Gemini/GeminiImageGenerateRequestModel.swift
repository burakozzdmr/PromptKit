//
//  GeminiImageGenerateRequestModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Foundation

public struct GeminiImageGenerateRequestModel: Codable {
    let contents: [Content]
    let generationConfig: GenerationConfig
}

extension GeminiImageGenerateRequestModel {
    struct Content: Codable {
        let parts: [Part]
    }
}

extension GeminiImageGenerateRequestModel.Content {
    struct Part: Codable {
        let text: String
    }
}

extension GeminiImageGenerateRequestModel {
    struct GenerationConfig: Codable {
        let responseModalities: [String]
    }
}
