//
//  GeminiTextGenerateModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 31.07.2025.
//

import Foundation

public struct GeminiTextGenerateModel: Codable {
    let candidates: [Candidate]
    let usageMetadata: MetaData
}

public extension GeminiTextGenerateModel {
    struct Candidate: Codable {
        let content: Content
        let finishReason: String
    }
}

public extension GeminiTextGenerateModel.Candidate {
    struct Content: Codable {
        let role: String
        let parts: [Part]
    }
}

public extension GeminiTextGenerateModel.Candidate.Content {
    struct Part: Codable {
        let text: String
    }
}

public extension GeminiTextGenerateModel {
    struct MetaData: Codable {
        let promptTokenCount: Int
        let candidatesTokenCount: Int
    }
}
