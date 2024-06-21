//
//  MockPostsApiManager.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
import RxSwift

class MockPostsApiManager: ApiManagerProtocol {
    var postsToReturn: [Post] = []
    var shouldThrowError = false
    
    func request<T: Decodable>(urlString: String) -> Single<T> {
        return Single.create { single in
            if self.shouldThrowError {
                single(.failure(URLError(.badServerResponse)))
            } else {
                if let comments = self.postsToReturn as? T {
                    single(.success(comments))
                } else {
                    single(.failure(URLError(.cannotParseResponse)))
                }
            }
            return Disposables.create()
        }
    }
}
