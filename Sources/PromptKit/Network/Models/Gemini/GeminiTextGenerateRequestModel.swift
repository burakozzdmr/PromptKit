//
//  GeminiRequestModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 31.07.2025.
//

import Foundation

struct GeminiTextGenerateRequestModel: Codable {
    let contents: [Content]
}

extension GeminiTextGenerateRequestModel {
    struct Content: Codable {
        let parts: [Part]
    }
}

extension GeminiTextGenerateRequestModel.Content {
    struct Part: Codable {
        let text: String?
        let inlineData: InlineData?
    }
}

extension GeminiTextGenerateRequestModel.Content.Part {
    struct InlineData: Codable {
        let mimeType: String
        let data: String
    }
}
