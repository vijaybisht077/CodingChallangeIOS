//
//  LoginViewController.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    private var viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
    }
    
    private func bindViewModel() {
        // Bind email and password text fields to viewModel properties
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        // Bind viewModel's isSubmitButtonEnabled to submitButton's isEnabled property
        viewModel.isSubmitButtonEnabled
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
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
