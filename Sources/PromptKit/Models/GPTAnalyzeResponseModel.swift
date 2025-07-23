//
//  GPTTextResponseModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

struct GPTAnalyzeResponseModel: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }

    let choices: [Choice]
}
