//
//  LoginViewModel.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    // Published properties to bind to the view
    @Published var email: String = "" {
        didSet {
            validateForm()
        }
    }
    @Published var password: String = "" {
        didSet {
            validateForm()
        }
    }
    @Published var isSubmitButtonEnabled: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Validate the form initially
        validateForm()
    }
    
    private func validateForm() {
        isSubmitButtonEnabled = isValidEmail(email) && isValidPassword(password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 && password.count <= 15
    }
}
