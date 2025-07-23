//
//  NetworkManager.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func sendRequest<T>(
        request: URLRequest,
        T: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) where T : Decodable, T : Encodable
}

class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }
}
