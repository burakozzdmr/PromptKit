//
//  File.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Foundation

struct ClaudeImageAnalyzeRequestModel: Codable {
    let model: String
    let max_tokens: Int
    let messages: [ClaudeMessage]
}

extension ClaudeImageAnalyzeRequestModel {
    struct ClaudeMessage: Codable {
        let role: String
        let content: [Content]
    }
}

extension ClaudeImageAnalyzeRequestModel.ClaudeMessage {
    struct Content: Codable {
        let type: String
        let source: Source?
        let text: String?
    }
}

extension ClaudeImageAnalyzeRequestModel.ClaudeMessage.Content {
    struct Source: Codable {
        let type: String
        let media_type: String
        let data: String
    }
}
