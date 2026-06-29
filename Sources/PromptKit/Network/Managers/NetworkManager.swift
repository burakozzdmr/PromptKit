//
//  NetworkManager.swift
//  PromptKit
//
//  Created by Burak Özdemir on 21.07.2025.
//

import Combine
import Foundation

// MARK: - NetworkManagerProtocol

protocol NetworkManagerProtocol {
    func sendRequest<T: Codable & Sendable>(
        request: URLRequest,
        T: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    func sendRequestPublisher<T: Codable>(
        request: URLRequest,
        T: T.Type
    ) -> AnyPublisher<T, NetworkError>
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
        completion: @escaping (Result<T, NetworkError>) -> Void
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
    
    func sendRequestPublisher<T: Codable>(
        request: URLRequest,
        T: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidURL
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    return data
                case 400..<500:
                    throw NetworkError.statusCodeError(httpResponse.statusCode)
                default:
                    throw NetworkError.requestFailedError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                
                if error is DecodingError {
                    return NetworkError.decodingFailedError
                } else {
                    return NetworkError.generalError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
