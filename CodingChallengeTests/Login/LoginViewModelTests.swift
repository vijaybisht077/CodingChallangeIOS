//
//  LoginViewModelTests.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
import XCTest
import Combine
@testable import CodingChallenge

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.isSubmitButtonEnabled)
    }
    
    func testValidEmail() {
        // Given
        let validEmails = ["test@example.com", "user.name@domain.co", "user+name@domain.com"]
        for email in validEmails {
            // When
            viewModel.email = email
            // Then
            XCTAssertTrue(viewModel.isValidEmail(email))
        }
    }
    
    func testInvalidEmail() {
        // Given
        let invalidEmails = ["plainaddress", "@missingusername.com", "username@.com"]
        for email in invalidEmails {
            // When
            viewModel.email = email
            // Then
            XCTAssertFalse(viewModel.isValidEmail(email))
        }
    }
    
    func testValidPassword() {
        // Given
        let validPasswords = ["Password1", "12345678", "abcdefgh"]
        for password in validPasswords {
            // When
            viewModel.password = password
            // Then
            XCTAssertTrue(viewModel.isValidPassword(password))
        }
    }
    
    func testInvalidPassword() {
        // Given
        let invalidPasswords = ["short", "toolongpassword123", " "]
        for password in invalidPasswords {
            // When
            viewModel.password = password
            // Then
            XCTAssertFalse(viewModel.isValidPassword(password))
        }
    }
    
    func testFormValidation() {
        // When
        viewModel.email = "test@example.com"
        viewModel.password = "password"
        // Then
        XCTAssertTrue(viewModel.isSubmitButtonEnabled)
        
        // When
        viewModel.email = "invalidemail"
        // Then
        XCTAssertFalse(viewModel.isSubmitButtonEnabled)
        
        // When
        viewModel.email = "test@example.com"
        viewModel.password = "short"
        // Then
        XCTAssertFalse(viewModel.isSubmitButtonEnabled)
        
        // When
        viewModel.email = "test@example.com"
        viewModel.password = "validpassword"
        // Then
        XCTAssertTrue(viewModel.isSubmitButtonEnabled)
    }
}

