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
        let validEmails = ["test@example.com", "user.name@domain.co", "user+name@domain.com"]
        for email in validEmails {
            viewModel.email = email
            XCTAssertTrue(viewModel.isValidEmail(email))
        }
    }
    
    func testInvalidEmail() {
        let invalidEmails = ["plainaddress", "@missingusername.com", "username@.com"]
        for email in invalidEmails {
            viewModel.email = email
            XCTAssertFalse(viewModel.isValidEmail(email))
        }
    }
    
    func testValidPassword() {
        let validPasswords = ["Password1", "12345678", "abcdefgh"]
        for password in validPasswords {
            viewModel.password = password
            XCTAssertTrue(viewModel.isValidPassword(password))
        }
    }
    
    func testInvalidPassword() {
        let invalidPasswords = ["short", "toolongpassword123", " "]
        for password in invalidPasswords {
            viewModel.password = password
            XCTAssertFalse(viewModel.isValidPassword(password))
        }
    }
    
    func testFormValidation() {
        viewModel.email = "test@example.com"
        viewModel.password = "password"
        XCTAssertTrue(viewModel.isSubmitButtonEnabled)
        
        viewModel.email = "invalidemail"
        XCTAssertFalse(viewModel.isSubmitButtonEnabled)
        
        viewModel.email = "test@example.com"
        viewModel.password = "short"
        XCTAssertFalse(viewModel.isSubmitButtonEnabled)
        
        viewModel.email = "test@example.com"
        viewModel.password = "validpassword"
        XCTAssertTrue(viewModel.isSubmitButtonEnabled)
    }
}
