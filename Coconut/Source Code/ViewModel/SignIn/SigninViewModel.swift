//
//  SigninViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/27/21.
//

import Foundation
import FirebaseAuth

class SigninViewModel : ObservableObject{
    
    // MARK: - Published Variables
    
    /// login request state
    @Published var stateLogin : NetworkRequestState = .UNDEFINED
    @Published var presentHomeTabView : Bool = false

    
    // MARK: - Functions :
    
    /// Signin with **Email**
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    func signIn(email : String , password : String) {
        stateLogin = .LOADING
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.stateLogin = .FAILED
                return
            }
            UserDefaults.standard.setValue(email, forKey: "Email")
            self.stateLogin = .SUCCESS
            self.presentHomeTabView = true
        }
    }
}
