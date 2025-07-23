//
//  GPTTextRequestModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

struct GPTTextRequestModel: Codable {
    let model: String
    let messages: [TextModel]
}

struct TextModel: Codable {
    let role: String
    let content: String
}
