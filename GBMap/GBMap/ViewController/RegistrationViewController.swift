//
//  RegistrationViewController.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 29.06.22.
//

import UIKit

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
    
    let realmManager = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
        else { return }
        realmManager.addUser(login: login, password: password)
    }
}