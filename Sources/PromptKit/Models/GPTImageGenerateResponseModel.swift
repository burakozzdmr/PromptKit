//
//  GPTImageGenerateResponseModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 1.08.2025.
//

import Foundation

public struct GPTImageGenerateResponseModel: Codable, Sendable {
    let created: Int
    let data: [GPTImageResponse]
}

public extension GPTImageGenerateResponseModel {
    struct GPTImageResponse: Codable, Sendable {
        let url: String
    }
}
