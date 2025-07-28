//
//  NetworkManager.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Foundation

// MARK: - NetworkManagerProtocol

protocol NetworkManagerProtocol {
    func sendRequest<T: Codable & Sendable>(
        request: URLRequest,
        T: T.Type,
        completion: @Sendable @escaping (Result<T, NetworkError>) -> Void
    )
}

// MARK: - NetworkManager

public class NetworkManager {
    private let session: URLSession
    
    public init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }
}

// MARK: - Methods

extension NetworkManager: NetworkManagerProtocol {
    func sendRequest<T: Codable & Sendable>(
        request: URLRequest,
        T: T.Type,
        completion: @Sendable @escaping (Result<T, NetworkError>) -> Void
    ){
        session.dataTask(with: request) { data, httpResponse, error in
            guard error == nil else {
                return completion(.failure(.requestFailedError))
            }
            
            if let httpResponse = httpResponse as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(.statusCodeError(httpResponse.statusCode)))
            }
            
            guard let data = data else {
                return completion(.failure(.noDataError))
            }
            
            do {
                let responseData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(.decodingFailedError))
            }
        }
        .resume()
    }
}
