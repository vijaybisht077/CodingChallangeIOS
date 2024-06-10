//
//  LoginViewController.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    private var viewModel = LoginViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
        
    }
    
    private func bindViewModel() {
        // Bind email and password text fields to viewModel properties
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
        
        // Bind viewModel's isSubmitButtonEnabled to submitButton's isEnabled property
        viewModel.$isSubmitButtonEnabled
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &cancellables)
    }
    
    @objc private func emailTextFieldChanged() {
        viewModel.email = emailTextField.text ?? ""
    }
    
    @objc private func passwordTextFieldChanged() {
        viewModel.password = passwordTextField.text ?? ""
    }
    
    private func setupUI() {
        // Initial UI setup
        submitButton.isEnabled = false
    }
    
    @IBAction func submitButtonTap(_ sender: Any) {
        let nextViewController = TabBarController()
        nextViewController.modalPresentationStyle = .fullScreen
        present(nextViewController, animated: true, completion: nil)
    }
}
