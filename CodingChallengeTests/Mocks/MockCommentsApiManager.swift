//
//  MockCommentsApiManager.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
import RxSwift

class MockCommentsApiManager: ApiManagerProtocol {
    var commentsToReturn: [Comment] = []
    var shouldThrowError = false
    
    func request<T: Decodable>(urlString: String) -> Single<T> {
        return Single.create { single in
            if self.shouldThrowError {
                single(.failure(URLError(.badServerResponse)))
            } else {
                if let comments = self.commentsToReturn as? T {
                    single(.success(comments))
                } else {
                    single(.failure(URLError(.cannotParseResponse)))
                }
            }
            return Disposables.create()
        }
    }
}

