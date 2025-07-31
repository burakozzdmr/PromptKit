//
//  GeminiResponseModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 31.07.2025.
//

import Foundation

public struct GeminiResponseModel: Codable, Sendable {
    let candidates: [Candidate]
}

public extension GeminiResponseModel {
    struct Candidate: Codable, Sendable {
        let content: String
    }
}
