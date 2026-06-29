//
//  GPTTextGenerateRequestModel.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

public struct GPTTextGenerateRequestModel: Codable {
    let model: String
    let instructions: String
    let input: String
}
