//
//  SignUpViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/24/21.
//

import Foundation
import FirebaseAuth

class SignupViewModel : ObservableObject {
    
    // MARK: - Published Variables
    
    @Published var name : String = ""
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var isImageSelected: Bool = false
    @Published var showImagePicker: Bool = false
    @Published var selectedImage: UIImage = UIImage()
    
    /// user singup **State**
    @Published var stateSignup : NetworkRequestState = .UNDEFINED
    @Published var errorSignup : SignupError? = nil
    @Published var showAlert : Bool = false
    @Published var isPresentedHomeTabView = false
    
    
    
    // MARK: - Functions :

    /// Signup with **Email**
    /// - Parameters:
    ///   - name: user name
    ///   - email: user email
    ///   - password: user email
    func signUp() {
        stateSignup = .LOADING
        /// Local validation 👇
        do{
            try isNameValid(name: name)
            try isEmailValid(email: email)
            try isPasswordValid(password:password)
        }catch {
            guard let error = error as? SignupError else {
                self.stateSignup = .FAILED
                return
            }
            self.stateSignup = .FAILED
            self.errorSignup = error
            self.showAlert = true
            return
        }
        /// Local validation passed  👆
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.stateSignup = .FAILED
                self.errorSignup = SignupError(rawValue: error.code)
                self.showAlert = true
                return
            }
            let user = UserModel(name: self.name, email: self.email)
            DatabaseManager.shared.insertUser(user: user) { result in
                if result {
                    self.stateSignup = .SUCCESS
                    UserDefaults.standard.set(self.email, forKey: "Email")
                    self.isPresentedHomeTabView = true
                }else{self.stateSignup = .FAILED}
            }
        }
    }
}

// MARK: - Local User Validation
extension SignupViewModel {
    
    ///  check validation of entered name
    /// - Parameter name: entered name
    /// - Throws: throws error if not valid
    private func isNameValid(name : String) throws {
        guard name.count > 0 else {
            throw SignupError.EMPTY_NAME
        }
    }
    
    ///  check validation of entered email
    /// - Parameter email: entered email
    /// - Throws: throws error if not valid
    private func isEmailValid(email : String) throws {
        guard email.count > 0 else {
            throw SignupError.EMPTY_EMAIL
        }
    }
    /// check validation of entered password
    /// - Parameter password: entered password
    /// - Throws: throws error if not valid
    private func isPasswordValid(password : String) throws {
        guard password.count > 0 else {
            throw SignupError.EMPTY_PASSWORD
        }
    }
}

// MARK: - Singup Errors
enum SignupError : Int , Error {
    case EMPTY_NAME
    case EMPTY_EMAIL
    case EMPTY_PASSWORD
    case WEAK_PASSWORD = 17026
    
    /// this is shown on alret **title**
    var title : String {
        switch self {
        case .EMPTY_NAME:
            return "Empty Name"
        case .EMPTY_EMAIL:
            return "Empty Email"
        case .EMPTY_PASSWORD:
            return "Empty Password"
        case .WEAK_PASSWORD:
            return "Weak Password"
        }
    }
    /// this is shown on alret **message**
    var description : String {
        switch self {
        case .EMPTY_NAME:
            return "Please enter your name"
        case .EMPTY_EMAIL:
            return "Please enter your email"
        case .EMPTY_PASSWORD:
            return "Please enter your password"
        case .WEAK_PASSWORD:
            return "The password must be 6 characters long or more."
        }
    }
}
