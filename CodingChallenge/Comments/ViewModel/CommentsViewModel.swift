//
//  CommentsViewModel.swift
//  CodingChallenge
//
//  Created by vijaybisht on 24/05/24.
//

import Foundation
import Combine

protocol CommentsViewModelProtocol {
    var comments: [Comment] { get set }
    var commentsPublisher: Published<[Comment]>.Publisher { get }
    var errorMessage: String? { get set }
    var errorMessagePublisher: Published<String?>.Publisher { get }
    func fetchComments(for postId: Int)
}

class CommentsViewModel: ObservableObject, CommentsViewModelProtocol {
    var commentsPublisher: Published<[Comment]>.Publisher { $comments }
    var errorMessagePublisher: Published<String?>.Publisher { $errorMessage }
    
    @Published var comments: [Comment] = []
    @Published var errorMessage: String?

    private let manager: ApiManagerProtocol
    init(manager: ApiManagerProtocol = ApiManager()) {
        self.manager = manager
    }

    func fetchComments(for postId: Int) {
        Task { @MainActor in
            do {
                let comments: [Comment] = try await manager.request(urlString: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments")
                self.comments = comments
            } catch {
                print(error)
            }
        }
    }
}
