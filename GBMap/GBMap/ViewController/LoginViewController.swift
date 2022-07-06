//
//  LoginViewController.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 20.06.22.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
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
    @IBOutlet var router: LoginRouter!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginBindings()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text
        else { return }
        
        if viewModel.checkLoginAndPassword(login: login, password: password) {
        //    performSegue(withIdentifier: "toMapStorybord", sender: self)
          //  router.toMain()
            router.toMap()
        } else {
            print("User не найден")
        }
        
    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        router.toRegistration()
    }
    
    @IBAction func unwindFromRegistrationVC(unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "fromRegistrationToLoginVC" else { return }
        let sourseVC = unwindSegue.source as! RegistrationViewController
        loginTextField.text = sourseVC.loginTextField.text ?? ""
        passwordTextField.text = sourseVC.passwordTextField.text ?? ""
    }
    
    @IBAction func unwindFromMapVC(unwindSegue: UIStoryboardSegue) {
        loginTextField.text = ""
        passwordTextField.text = ""
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
        .bind { [weak loginButton] inputFilled in
            loginButton?.isEnabled = inputFilled
        }
    }
}

final class LoginRouter: BaseRouter {
    func toMap() {
        perform(segue: "toMapStorybord")
    }
    func toRegistration() {
        perform(segue: "toRegistrationViewController")
    }
}
