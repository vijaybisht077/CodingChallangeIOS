//
//  LoginViewModelTests.swift
//  CodingChallengeTests
//
//  Created by vijaybisht on 10/06/24.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
@testable import CodingChallenge

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.email.value, "")
        XCTAssertEqual(viewModel.password.value, "")
        XCTAssertFalse(viewModel.isSubmitButtonEnabled.value)
    }
    
    func testValidEmail() {
        // Given
        let validEmails = ["test@example.com", "user.name@domain.co", "user+name@domain.com"]
        for email in validEmails {
            // When
            viewModel.email.accept(email)
            // Then
            XCTAssertTrue(viewModel.isValidEmail(email))
        }
    }
    
    func testInvalidEmail() {
        // Given
        let invalidEmails = ["plainaddress", "@missingusername.com", "username@.com"]
        for email in invalidEmails {
            // When
            viewModel.email.accept(email)
            // Then
            XCTAssertFalse(viewModel.isValidEmail(email))
        }
    }
    
    func testValidPassword() {
        // Given
        let validPasswords = ["Password1", "12345678", "abcdefgh"]
        for password in validPasswords {
            // When
            viewModel.password.accept(password)
            // Then
            XCTAssertTrue(viewModel.isValidPassword(password))
        }
    }
    
    func testInvalidPassword() {
        // Given
        let invalidPasswords = ["short", "toolongpassword123", " "]
        for password in invalidPasswords {
            // When
            viewModel.password.accept(password)
            // Then
            XCTAssertFalse(viewModel.isValidPassword(password))
        }
    }
    
    func testFormValidation() {
        // When
        viewModel.email.accept("test@example.com")
        viewModel.password.accept("password")
        // Then
        XCTAssertTrue(viewModel.isSubmitButtonEnabled.value)
        
        // When
        viewModel.email.accept("invalidemail")
        // Then
        XCTAssertFalse(viewModel.isSubmitButtonEnabled.value)
        
        // When
        viewModel.email.accept("test@example.com")
        viewModel.password.accept("short")
        // Then
        XCTAssertFalse(viewModel.isSubmitButtonEnabled.value)
        
        // When
        viewModel.email.accept("test@example.com")
        viewModel.password.accept("validpassword")
        // Then
        XCTAssertTrue(viewModel.isSubmitButtonEnabled.value)
    }
}
