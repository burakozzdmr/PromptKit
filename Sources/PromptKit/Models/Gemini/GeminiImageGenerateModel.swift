//
//  GeminiImageGenerateModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Foundation

struct GeminiImageGenerateModel: Codable {
    let candidates: [Candidate]
}

extension GeminiImageGenerateModel {
    struct Candidate: Codable {
        let content: Content
    }
}

extension GeminiImageGenerateModel.Candidate {
    struct Content: Codable {
        let parts: [Part]
    }
}

extension GeminiImageGenerateModel.Candidate.Content {
    struct Part: Codable {
        let text: String?
        let inlineData: InlineData?
    }
}

extension GeminiImageGenerateModel.Candidate.Content.Part {
    struct InlineData: Codable {
        let mimeType: String
        let data: String
    }
}
