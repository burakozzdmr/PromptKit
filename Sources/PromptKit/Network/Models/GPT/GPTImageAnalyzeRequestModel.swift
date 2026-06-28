//
//  GPTImageAnalyzeRequestModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 29.06.2026.
//

import Foundation

struct GPTImageAnalyzeRequestModel: Codable {
    let model: String
    let input: [ImageAnalyzeModel]
}

extension GPTImageAnalyzeRequestModel {
    struct ImageAnalyzeModel: Codable {
        let role: String
        let content: [AnalyzeModel]
    }
}

extension GPTImageAnalyzeRequestModel.ImageAnalyzeModel {
    struct AnalyzeModel: Codable {
        let type: String
        let text: String?
        let image_url: String?
    }
}
