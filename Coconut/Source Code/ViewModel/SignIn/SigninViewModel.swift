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
    @Published var stateSignin : NetworkRequestState = .UNDEFINED
    @Published var errorSignin : SigninError? = nil
    @Published var presentHomeTabView : Bool = false
    @Published var showAlert : Bool = false

    
    // MARK: - Functions :
    
    /// Signin with **Email**
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    func signIn(email : String , password : String) {
        stateSignin = .LOADING
        /// Local validation 👇
        do{
            try isEmailValid(email: email)
            try isPasswordValid(password:password)
        }catch {
            guard let error = error as? SigninError else {
                self.stateSignin = .FAILED
                return
            }
            self.stateSignin = .FAILED
            self.errorSignin = error
            self.showAlert = true
            return
        }
        /// Local validation passed  👆
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.stateSignin = .FAILED
                self.errorSignin = SigninError(rawValue: error.code)
                self.showAlert = true
                return
            }
            UserDefaults.standard.setValue(email, forKey: "Email")
            self.stateSignin = .SUCCESS
            self.presentHomeTabView = true
        }
    }
}
// MARK: - Local User Validation
extension SigninViewModel {
    
    ///  check validation of entered email
    /// - Parameter email: entered email
    /// - Throws: throws error if not valid
    private func isEmailValid(email : String) throws {
        guard email.count > 0 else {
            throw SigninError.EMPTY_EMAIL
        }
    }
    /// check validation of entered password
    /// - Parameter password: entered password
    /// - Throws: throws error if not valid
    private func isPasswordValid(password : String) throws {
        guard password.count > 0 else {
            throw SigninError.EMPTY_PASSWORD
        }
    }
}

// MARK: - Singin Errors
enum SigninError : Int , Error {
    case EMPTY_EMAIL
    case EMPTY_PASSWORD
    case WRONG_PASSWORD = 17009
    case TEMPORARILY_DISABLED = 17010
    /// this is shown on alret **title**
    var title : String {
        switch self {
        case .EMPTY_EMAIL:
            return "Empty Email"
        case .EMPTY_PASSWORD:
            return "Empty Password"
        case .WRONG_PASSWORD:
            return "Wrong Password"
        case .TEMPORARILY_DISABLED:
            return "Temporarily Disabled"
        }
    }
    /// this is shown on alret **message**
    var description : String {
        switch self {
        case .EMPTY_EMAIL:
            return "Please enter your email"
        case .EMPTY_PASSWORD:
            return "Please enter your password"
        case .WRONG_PASSWORD:
            return "Please enter the correct password"
        case .TEMPORARILY_DISABLED:
            return "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."
        }
    }
}
