//
//  GPTTextResponseModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

public struct GPTAnalyzeResponseModel: Codable {
    let id: String
    let output: [AnalyzeOutputModel]
}

extension GPTAnalyzeResponseModel {
    struct AnalyzeOutputModel: Codable {
        let type: String
        let role: String?
        let content: [OutputModel]?
    }
}

extension GPTAnalyzeResponseModel {
    struct OutputModel: Codable {
        let type: String
        let text: String?
    }
}
