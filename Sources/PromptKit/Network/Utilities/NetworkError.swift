//
//  NetworkError.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case requestFailedError
    case requestTimedOutError
    case cannotFindHost
    case statusCodeError(Int)
    case noDataError
    case decodingFailedError
    case generalError(Error)
    
    public var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailedError:
            return "Request failed"
        case .requestTimedOutError:
            return "Request timed out"
        case .cannotFindHost:
            return "Cannot find host"
        case .statusCodeError(let statusCode):
            return "Status code Error: \(statusCode)"
        case .noDataError:
            return "No data returned"
        case .decodingFailedError:
            return "Decoding failed"
        case .generalError(let error):
            return error.localizedDescription
        }
    }
}
