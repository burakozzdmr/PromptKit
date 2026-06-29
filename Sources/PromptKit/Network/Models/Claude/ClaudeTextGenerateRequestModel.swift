//
//  ClaudeTextGenerateRequestModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Foundation

struct ClaudeTextGenerateRequestModel: Codable {
    let model: String
    let max_tokens: Int
    let messages: [ClaudeMessage]
}

extension ClaudeTextGenerateRequestModel {
    struct ClaudeMessage: Codable {
        let role: String
        let content: String
    }
}
