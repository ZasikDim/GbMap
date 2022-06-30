//
//  LoginViewController.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 20.06.22.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var router: LoginRouter!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}

final class LoginRouter: BaseRouter {
    func toMap() {
        perform(segue: "toMapStorybord")
    }
    func toRegistration() {
        perform(segue: "toRegistrationViewController")
    }
}
