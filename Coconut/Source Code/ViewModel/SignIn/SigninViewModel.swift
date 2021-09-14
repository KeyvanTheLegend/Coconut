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
    @Published var showAlert : Bool = false
    
    
    // MARK: - Functions :
    
    /// Signin with **Email**
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    func signIn(email :String , password : String) {
        updateView(with: .LOADING)
        do {
            try isEmailValid(email: email)
            try isPasswordValid(password:password)
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    let signinError = SigninError(rawValue: error.code)
                    self?.updateView(error: signinError)
                    return
                }
                DatabaseManager.shared.getUser(withEmail: email) { [weak self] result in
                    switch result {
                    case .success(let user):
                        if let token = UserDefaults.standard.string(forKey: "FCMToken"){
                            DatabaseManager.shared.updateUserToken(withEmail: email, to: token)
                        }
                        Session.shared.updateUserDefaults(withUser: user)
                        DispatchQueue.main.async {
                            self?.updateView(with: .SUCCESS)
                        }
                        /// update session
                        Session.shared.update()
                        break
                    case.failure(_):
                        DispatchQueue.main.async {
                            self?.updateView(error: .UNABLE_TO_FETCH_USER)
                        }
                        break
                    }
                }
            }
        }
        catch {
            guard let error = error as? SigninError else {
                self.stateSignin = .FAILED
                return
            }
            self.stateSignin = .FAILED
            self.errorSignin = error
            self.showAlert = true
            return
        }
    }
    
    /// update view with current state
    /// - Parameters:
    ///   - state: signIn state
    ///   - error: error if exist
    private func updateView(
        with state: NetworkRequestState = .FAILED,
        error : SigninError? = nil) {
        switch state {
        case .SUCCESS:
            self.stateSignin = state
            break
        case .FAILED:
            self.errorSignin = error
            self.stateSignin = state
            self.showAlert = true
            break
        case .LOADING :
            self.stateSignin = state
            break
        default :
            break
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
    case UNABLE_TO_FETCH_USER
    case EMAIL_INVALID = 17008
    case WRONG_PASSWORD = 17009
    case USER_NOT_FOUND = 17011
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
        case .USER_NOT_FOUND:
            return "User dose not exist"
        case .EMAIL_INVALID:
            return "Invalid email"
        case .TEMPORARILY_DISABLED:
            return "Temporarily Disabled"
        case .UNABLE_TO_FETCH_USER:
            return "Unable to fetch user"
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
        case .USER_NOT_FOUND:
            return "Please check if the entered email is correct"
        case .EMAIL_INVALID:
            return "Please enter a valid email"
        case .TEMPORARILY_DISABLED:
            return "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."
        case .UNABLE_TO_FETCH_USER:
            return "Please try again"
        }
    }
}
