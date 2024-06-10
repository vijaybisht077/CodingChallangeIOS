//
//  PostsViewModelTests.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
import XCTest
import Combine
import CoreData
@testable import CodingChallenge

class PostsViewModelTests {

    var viewModel: PostsViewModel!
    var mockApiManager: MockPostsApiManager!
    var mockPersistentStorage: MockPersistentStorage!
    var cancellables: Set<AnyCancellable>!

    func setUp() {
        mockApiManager = MockPostsApiManager()
        mockPersistentStorage = MockPersistentStorage()
        viewModel = PostsViewModel(manager: mockApiManager)
        cancellables = Set<AnyCancellable>()
    }

    func tearDown() {
        viewModel = nil
        mockApiManager = nil
        mockPersistentStorage = nil
        cancellables = nil
    }

    func testLoadPostsFromCoreData() {
        // Create a mock CDPost object
        let mockCDPost = CDPost(context: mockPersistentStorage.context)
        mockCDPost.id = 1
        mockCDPost.userId = 1
        mockCDPost.title = "Test Title"
        mockCDPost.body = "Test Body"
        
        // Save the mock object
        try! mockPersistentStorage.context.save()
        
        // Load posts
        viewModel.loadPosts()
        
        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts.first?.title, "Test Title")
    }

    func testLoadPostsFromNetwork() async {
        // Prepare mock data to return from network request
        let mockPosts = [Post(userId: 1, id: 1, title: "Test Title", body: "Test Body")]
        mockApiManager.postsToReturn = mockPosts

        await viewModel.fetchPostsFromNetwork()

        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts.first?.title, "Test Title")
    }

    func testLoadFavorites() {
        let mockPost = Post(userId: 1, id: 1, title: "Favorite Title", body: "Favorite Body")
        let encodedFavorites = try! JSONEncoder().encode([mockPost])
        UserDefaults.standard.set(encodedFavorites, forKey: "favorites")

        viewModel.loadFavorites()

        XCTAssertEqual(viewModel.favoritePosts.count, 1)
        XCTAssertEqual(viewModel.favoritePosts.first?.title, "Favorite Title")
    }

    func testToggleFavorite() {
        let post = Post(userId: 1, id: 1, title: "Test Title", body: "Test Body")

        // Test adding favorite
        viewModel.toggleFavorite(post: post)
        XCTAssertEqual(viewModel.favoritePosts.count, 1)
        XCTAssertTrue(viewModel.isFavorite(post: post))

        // Test removing favorite
        viewModel.toggleFavorite(post: post)
        XCTAssertEqual(viewModel.favoritePosts.count, 0)
        XCTAssertFalse(viewModel.isFavorite(post: post))
    }

    func testIsFavorite() {
        let post = Post(userId: 1, id: 1, title: "Test Title", body: "Test Body")
        viewModel.favoritePosts = [post]

        XCTAssertTrue(viewModel.isFavorite(post: post))

        let nonFavoritePost = Post(userId: 2, id: 2, title: "Non-Favorite Title", body: "Non-Favorite Body")
        XCTAssertFalse(viewModel.isFavorite(post: nonFavoritePost))
    }

}
