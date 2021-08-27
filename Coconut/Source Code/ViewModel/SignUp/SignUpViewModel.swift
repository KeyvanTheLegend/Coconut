//
//  SignUpViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/24/21.
//

import Foundation
import FirebaseAuth

///  User **SIGNUP** states
enum SignupState {
    case UNDEFINED
    case LOADING
    case FAILED
    case SUCCESS
}

class SignUpViewModel : ObservableObject {
    
    // MARK: - Published Variables
    
    /// user singup **State**
    @Published var state : SignupState = .UNDEFINED
    @Published var isPresentedHomeTabView = false
    
    // MARK: - Functions :

    /// Signup with **Email**
    /// - Parameters:
    ///   - name: user name
    ///   - email: user email
    func signUp(name: String , email : String , password : String) {
        state = .LOADING
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {return}
            let user = UserModel(name: name, email: email)
            DatabaseManager.shared.insertUser(user: user) { result in
                if result {
                    self.state = .SUCCESS
                    print(email)
                    UserDefaults.standard.set(email, forKey: "Email") //Bool

                }
                else{
                    self.state = .FAILED
                }
                self.publish(with: self.state)
            }
        }
    }
    
    private func publish(with state : SignupState) {
        switch state {
        case .SUCCESS:
            isPresentedHomeTabView = true
            break
        default:
            break
        }
    }
}
