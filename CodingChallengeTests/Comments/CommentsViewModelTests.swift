//
//  CommentsViewModelTests.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
import XCTest
import Combine
@testable import CodingChallenge

class CommentsViewModelTests: XCTestCase {

    var viewModel: CommentsViewModel!
    var mockApiManager: MockCommentsApiManager!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockApiManager = MockCommentsApiManager()
        viewModel = CommentsViewModel(manager: mockApiManager)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockApiManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchCommentsSuccess() async {
        // Given
        let mockComments = [Comment(id: 1,
                                    postId: 1,
                                    name: "Test Comment",
                                    email: "test@example.com",
                                    body: "Test Body")]
        mockApiManager.commentsToReturn = mockComments
        let expectation = XCTestExpectation(description: "Fetch comments successfully")
        viewModel.commentsPublisher
            .sink { comments in
                if comments.count == mockComments.count {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        viewModel.fetchComments(for: 1)
        await fulfillment(of: [expectation])
        // Then
        XCTAssertEqual(viewModel.comments.first?.postId, mockComments.first?.postId)
        XCTAssertNil(viewModel.errorMessage)
    }
}

