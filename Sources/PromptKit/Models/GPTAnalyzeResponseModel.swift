//
//  GPTTextResponseModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

public struct GPTAnalyzeResponseModel: Codable, Sendable {
    public let choices: [Choice]
}

public extension GPTAnalyzeResponseModel {
    struct Choice: Codable, Sendable {
        public let message: Message
    }
}

public extension GPTAnalyzeResponseModel.Choice {
    struct Message: Codable, Sendable {
         let content: String
    }
}
