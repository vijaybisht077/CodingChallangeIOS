//
//  CommentsViewModelTests.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import XCTest
import RxSwift
import RxCocoa
@testable import CodingChallenge

class CommentsViewModelTests: XCTestCase {

    var viewModel: CommentsViewModel!
    var mockApiManager: MockCommentsApiManager!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockApiManager = MockCommentsApiManager()
        viewModel = CommentsViewModel(manager: mockApiManager)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        mockApiManager = nil
        disposeBag = nil
        super.tearDown()
    }

    func testFetchCommentsSuccess() {
        // Given
        let mockComments = [Comment(id: 1,
                                    postId: 1,
                                    name: "Test Comment",
                                    email: "test@example.com",
                                    body: "Test Body")]
        mockApiManager.commentsToReturn = mockComments
        let expectation = XCTestExpectation(description: "Fetch comments successfully")
        
        viewModel.commentsPublisher
            .subscribe(onNext: { comments in
                if comments.count == mockComments.count {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        // When
        viewModel.fetchComments(for: 1)
        
        // Wait for expectations
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.comments.first?.postId, mockComments.first?.postId)
        XCTAssertNil(viewModel.errorMessage)
    }

}
