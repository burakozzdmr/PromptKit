//
//  ClaudeGenerateModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Foundation

struct ClaudeGenerateModel: Codable {
    let id: String
    let type: String
    let role: String
    let content: [Content]
    let model: String?
    let stop_reason: String
    let stop_sequence: String?
    let usage: ClaudeUsage
}

extension ClaudeGenerateModel {
    struct Content: Codable {
        let type: String
        let text: String?
    }
}

extension ClaudeGenerateModel {
    struct ClaudeUsage: Codable {
        let input_tokens: Int
        let output_tokens: Int
    }
}
