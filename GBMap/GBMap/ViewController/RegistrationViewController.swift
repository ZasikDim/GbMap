//
//  RegistrationViewController.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 29.06.22.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.autocorrectionType = .no
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var registrationButton: UIButton!
    
    private let realmManager = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginBindings() 

    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
        else { return }
        realmManager.addUser(login: login, password: password)
    }
    @IBAction func cancleButtonTapped(_ sender: UIButton) {
        loginTextField.text = ""
        passwordTextField.text = ""
        performSegue(withIdentifier: "fromRegistrationToLoginVC", sender: self)
    }
    
    func configureLoginBindings() {
        Observable
        .combineLatest(
            loginTextField.rx.text,
            passwordTextField.rx.text
        )
        .map { login, password in
            return !(login ?? "").isEmpty && (password ?? "").count >= 5
        }
        .bind { [weak registrationButton] inputFilled in
            registrationButton?.isEnabled = inputFilled
        }
    }
}
