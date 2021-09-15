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
    
    /// user singup **State**
    @Published var state : NetworkRequestState = .UNDEFINED
    @Published var errorSignup : SignupError? = nil
    @Published var showAlert : Bool = false
    
    // MARK: - Functions :

    /// Signup with **Email**
    /// - Description : First will **Auth** user then **Insert** user to database ,
    ///  if user has profile picture , will **Upload** profile picture and insert user with profile picture url
    /// - Parameters:
    ///   - name: user name
    ///   - email: user email
    ///   - password: user email
    ///- TODO: separate auth step form user information database create
    func signUp(
        name : String,
        email: String,
        password: String,
        profilePicture : UIImage?) {
        updateView(with : .LOADING)
        do {
            try isNameValid(name: name)
            try isEmailValid(email: email)
            try isPasswordValid(password:password)
            /// Authantication
            Auth.auth().createUser(
                withEmail: email,
                password: password) { _ , error in
                if let error = error {
                    let errorSignup = SignupError(rawValue: error.code)
                    self.updateView(error : errorSignup)
                    return
                }
                /// Database
                self.createUser(
                    name: name,
                    email: email,
                    profilePicture: profilePicture)
            }
        }
        catch {
            guard let error = error as? SignupError else {
                updateView(error : .UNKNOWEN)
                return
            }
            updateView(error : error)
            return
        }
    }
    
    /// create user model then call **inserUser** function,
    /// if user have profile picture , it will  upload the picture and then call inserUser
    /// - Parameters:
    ///   - name: user name
    ///   - email: user email
    ///   - profilePicture: user profile picture
    private func createUser(
        name : String,
        email : String,
        profilePicture: UIImage?) {
        
        var user = UserModel(name: name, email: email)
        
        guard let profilePicture = profilePicture else{
            self.insertUser(user)
            return
        }
        
        StorageManager.shared.uploadProfilePicture(
            with: profilePicture,
            fileName: user.pictureFileName) { result in
            switch result {
            case .success(let uploadedPictureUrl):
                user.picture = uploadedPictureUrl
                self.insertUser(user)
                return
            case .failure(_):
                self.updateView(error: .UNABLE_TO_UPLOAD_PICTURE)
                return
            }
        }
    }
    
    /// insert user into database
    /// - Parameter user: user data
    private func insertUser(_ user: UserModel){
        DatabaseManager.shared.insertUser(user: user) { success in
            if success {
                Session.shared.updateUserDefaults(withUser: user)
                Session.shared.update()
                self.updateView(with: .SUCCESS)
            } else{ self.updateView(error : .UNABLE_TO_INSERT_USER) }
        }
    }
    
    /// update view with current state
    /// - Parameters:
    ///   - state: signup state
    ///   - error: error if exist
    private func updateView(
        with state: NetworkRequestState = .FAILED,
        error : SignupError? = nil) {
        DispatchQueue.main.async {
            switch state {
            case .SUCCESS:
                self.state = state
                break
            case .FAILED:
                self.errorSignup = error
                self.state = state
                self.showAlert = true
                break
            case .LOADING :
                self.state = state
                break
            default :
                break
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
    case USER_EXIST = 17007
    case INVALID_EMAIL = 17008
    case UNABLE_TO_UPLOAD_PICTURE
    case UNABLE_TO_INSERT_USER
    case UNKNOWEN


    /// this is shown on alret **title**
    var title : String {
        switch self {
        case .EMPTY_NAME:
            return "Empty Name."
        case .EMPTY_EMAIL:
            return "Empty Email."
        case .EMPTY_PASSWORD:
            return "Empty Password."
        case .WEAK_PASSWORD:
            return "Weak Password."
        case .USER_EXIST:
            return "User exist."
        case .UNABLE_TO_UPLOAD_PICTURE:
            return "Unable to upload."
        case .UNABLE_TO_INSERT_USER:
            return "Unable to create user."
        case .UNKNOWEN:
            return "Error."
        case .INVALID_EMAIL:
            return "Invalid Email."
        }
    }
    /// this is shown on alret **message**
    var description : String {
        switch self {
        case .EMPTY_NAME:
            return "Please enter your name."
        case .EMPTY_EMAIL:
            return "Please enter your email."
        case .EMPTY_PASSWORD:
            return "Please enter your password."
        case .WEAK_PASSWORD:
            return "The password must be 6 characters long or more."
        case .UNABLE_TO_UPLOAD_PICTURE:
            return "Unable to upload profile picture please try again."
        case .USER_EXIST:
            return "This email already exist, please use an other email."
        case .UNABLE_TO_INSERT_USER:
            return "please try again."
        case .UNKNOWEN:
            return "please try again."
        case .INVALID_EMAIL:
            return "Please enter a vaild email address."
        }
    }
}
