//
//  SignUpViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/24/21.
//

import Foundation
import FirebaseAuth

///  Network request state such as firebase database changes
enum NetworkRequestState {
    case UNDEFINED
    case LOADING
    case FAILED
    case SUCCESS
    func isLoading() -> Bool {
        return self == .LOADING
    }
}

class SignUpViewModel : ObservableObject {
    
    // MARK: - Published Variables
    
    /// user singup **State**
    @Published var stateSignup : NetworkRequestState = .UNDEFINED
    @Published var isPresentedHomeTabView = false
    
    // MARK: - Functions :

    /// Signup with **Email**
    /// - Parameters:
    ///   - name: user name
    ///   - email: user email
    func signUp(name: String , email : String , password : String) {
        stateSignup = .LOADING
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.stateSignup = .FAILED
                return
            }
            let user = UserModel(name: name, email: email)
            DatabaseManager.shared.insertUser(user: user) { result in
                if result {
                    self.stateSignup = .SUCCESS
                    UserDefaults.standard.set(email, forKey: "Email")
                }
                else{
                    self.stateSignup = .FAILED
                }
                self.publish(with: self.stateSignup)
            }
        }
    }
    
    private func publish(with state : NetworkRequestState) {
        switch state {
        case .SUCCESS:
            isPresentedHomeTabView = true
            break
        default:
            break
        }
    }
}
