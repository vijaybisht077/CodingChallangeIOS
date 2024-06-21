//
//  PostsViewModelTests.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
import XCTest
import CoreData
@testable import CodingChallenge

class PostsViewModelTests {

    var viewModel: PostsViewModel!
    var mockApiManager: MockPostsApiManager!
    var mockPersistentStorage: MockPersistentStorage!

    func setUp() {
        mockApiManager = MockPostsApiManager()
        mockPersistentStorage = MockPersistentStorage()
        viewModel = PostsViewModel(manager: mockApiManager)
    }

    func tearDown() {
        viewModel = nil
        mockApiManager = nil
        mockPersistentStorage = nil
    }

    func testLoadPostsFromCoreData() {
        // Given
        let mockCDPost = CDPost(context: mockPersistentStorage.context)
        mockCDPost.id = 1
        mockCDPost.userId = 1
        mockCDPost.title = "Test Title"
        mockCDPost.body = "Test Body"
        try! mockPersistentStorage.context.save()
        
        // When
        viewModel.loadPosts()
        
        // Then
        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts.first?.title, "Test Title")
    }

    func testLoadPostsFromNetwork() async {
        // Prepare mock data to return from network request
        // Given
        let mockPosts = [Post(userId: 1, id: 1, title: "Test Title", body: "Test Body")]
        mockApiManager.postsToReturn = mockPosts

        // When
        viewModel.fetchPostsFromNetwork()

        // Then
        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts.first?.title, "Test Title")
    }

    func testLoadFavorites() {
        // Given
        let mockPost = Post(userId: 1, id: 1, title: "Favorite Title", body: "Favorite Body")
        let encodedFavorites = try! JSONEncoder().encode([mockPost])
        UserDefaults.standard.set(encodedFavorites, forKey: "favorites")

        // When
        viewModel.loadFavorites()

        // Then
        XCTAssertEqual(viewModel.favoritePosts.count, 1)
        XCTAssertEqual(viewModel.favoritePosts.first?.title, "Favorite Title")
    }

    func testToggleFavorite() {
        // Given
        let post = Post(userId: 1, id: 1, title: "Test Title", body: "Test Body")

        // When
        viewModel.toggleFavorite(post: post)
        
        // Then
        XCTAssertEqual(viewModel.favoritePosts.count, 1)
        XCTAssertTrue(viewModel.isFavorite(post: post))

        // When
        viewModel.toggleFavorite(post: post)
        
        // Then
        XCTAssertEqual(viewModel.favoritePosts.count, 0)
        XCTAssertFalse(viewModel.isFavorite(post: post))
    }

    func testIsFavorite() {
        // Givne
        let post = Post(userId: 1, id: 1, title: "Test Title", body: "Test Body")
        // When
        viewModel.favoritePosts = [post]
        // Then
        XCTAssertTrue(viewModel.isFavorite(post: post))

        // When
        let nonFavoritePost = Post(userId: 2, id: 2, title: "Non-Favorite Title", body: "Non-Favorite Body")
        // Then
        XCTAssertFalse(viewModel.isFavorite(post: nonFavoritePost))
    }

}

