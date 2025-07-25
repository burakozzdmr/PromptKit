//
//  GPTTextRequestModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

struct GPTAnalyzeRequestModel: Codable {
    let model: String
    let messages: [AnalyzeModel]
}

struct AnalyzeModel: Codable {
    let role: String
    let content: String?
}
