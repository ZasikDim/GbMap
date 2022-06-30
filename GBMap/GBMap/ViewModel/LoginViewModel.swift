//
//  LoginViewModel.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 21.06.22.
//

import Foundation

final class LoginViewModel {
    
    let realmManager = RealmManager()
    
    func checkLoginAndPassword(login: String, password: String) -> Bool {
        if realmManager.checkLoginAndPasword(login: login, password: password) {
            return true
        }
        else {
            return false
        }
    }

}
