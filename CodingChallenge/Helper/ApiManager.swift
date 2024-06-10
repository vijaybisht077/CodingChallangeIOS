//
//  ApiManager.swift
//  CodingChallenge
//
//  Created by vijaybisht on 24/05/24.
//

import Foundation
import UIKit

enum DataError: Error {
    case invalidURL
    case invalidResponse
}

public protocol ApiManagerProtocol {
    func request<T: Decodable>(urlString: String) async throws -> T
}

public struct ApiManager: ApiManagerProtocol {
    
    public func request<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw DataError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
