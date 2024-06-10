//
//  MockPostsApiManager.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
class MockPostsApiManager: ApiManagerProtocol {
    var postsToReturn: [Post] = []
    var shouldThrowError = false
    
    func request<T>(urlString: String) async throws -> T where T : Decodable {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return postsToReturn as! T
    }
}
