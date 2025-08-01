//
//  GPTImageGenerateRequestModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 1.08.2025.
//

import Foundation

struct GPTImageGenerateRequestModel: Codable {
    let model: String
    let prompt: String
    let n: Int
    let size: String
}
