//
//  MockCommentsApiManager.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
class MockCommentsApiManager: ApiManagerProtocol {
    var commentsToReturn: [Comment] = []
    var shouldThrowError = false
    
    func request<T>(urlString: String) async throws -> T where T : Decodable {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return commentsToReturn as! T
    }
}
