//
//  GeminiRequestModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 31.07.2025.
//

import Foundation

struct GeminiRequestModel: Codable {
    let contents: [Content]
}

extension GeminiRequestModel {
    struct Content: Codable {
        let parts: [Part]
    }
}

extension GeminiRequestModel.Content {
    struct Part: Codable {
        let text: String
    }
}
