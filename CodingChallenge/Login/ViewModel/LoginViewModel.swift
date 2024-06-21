//
//  LoginViewModel.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: NSObject {
    // RxSwift subjects to bind to the view
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let isSubmitButtonEnabled = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        setupBindings()
    }
    
    private func setupBindings() {
        // Combine email and password streams and validate form
        Observable
            .combineLatest(email, password)
            .map { [weak self] email, password in
                return self?.isValidEmail(email) == true && self?.isValidPassword(password) == true
            }
            .bind(to: isSubmitButtonEnabled)
            .disposed(by: disposeBag)
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
