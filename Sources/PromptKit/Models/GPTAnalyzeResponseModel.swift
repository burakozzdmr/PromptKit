//
//  GPTTextResponseModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

public struct GPTAnalyzeResponseModel: Codable, Sendable {
    public struct Choice: Codable, Sendable {
        public struct Message: Codable, Sendable {
             let content: String
        }
        public let message: Message
    }

    public let choices: [Choice]
}
