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
    @Published var profilePictureUrl : String = ""

    @Published var isImageSelected: Bool = false
    @Published var showImagePicker: Bool = false
    @Published var selectedImage: UIImage? = nil
    
    /// user singup **State**
    @Published var stateSignup : NetworkRequestState = .UNDEFINED
    @Published var errorSignup : SignupError? = nil
    @Published var showAlert : Bool = false
    @Published var isPresentedHomeTabView = false
    
    
    
    // MARK: - Functions :

    /// Signup with **Email**
    /// - Description : First will **Auth** user then **Insert** user to database ,
    ///  if user has profile picture , will **Upload** profile picture and insert user with profile picture url
    /// - Parameters:
    ///   - name: user name
    ///   - email: user email
    ///   - password: user email
    ///- TODO: separate auth step form user information database create
    func signUp(name : String , email: String , password: String , profilePicture : UIImage?) {
        stateSignup = .LOADING
        do{
            try isNameValid(name: name)
            try isEmailValid(email: email)
            try isPasswordValid(password:password)
            /// Authantication
            Auth.auth().createUser(
                withEmail: email,
                password: password) { _ , error in
                if let error = error {
                    self.stateSignup = .FAILED
                    self.errorSignup = SignupError(rawValue: error.code)
                    print(error.code)
                    
                    self.showAlert = true
                    return
                }
                /// Database
                self.createUser(
                    name: name,
                    email: email,
                    profilePicture: profilePicture
                )
            }
        }
        catch {
            guard let error = error as? SignupError else {
                self.stateSignup = .FAILED
                return
            }
            self.stateSignup = .FAILED
            self.errorSignup = error
            self.showAlert = true
            return
        }
    }
    
    private func createUser(
        name : String,
        email : String,
        profilePicture: UIImage?) {
        let userToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        
        var user = UserModel(name: name, email: email,picture: "",userToken: userToken)
        
        guard let profilePicture = profilePicture else{
            self.insertUser(user)
            return
        }
        uploadProfilePicture(
            picture:profilePicture,
            for: user) { result in
            
            switch result {
            
            case .success(let profilePictureUrl):
                user.picture = profilePictureUrl
                self.insertUser(user)
                return
            case .failure(_):
                self.errorSignup = .UNABLE_TO_UPLOAD_PICTURE
                self.stateSignup = .FAILED
                return
            }
        }
    }
    private func uploadProfilePicture(
        picture : UIImage,
        for user: UserModel,
        completion : @escaping (Result<String,Error>)  -> Void) {
        
        StorageManager.shared.uploadProfilePicture(
            with: picture.pngData()!,
            fileName: user.pictureFileName){ result in
            
            switch result {
            
            case .success(let url):
                completion(.success(url))
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    private func insertUser(_ user: UserModel){
        
        DatabaseManager.shared.insertUser(user: user) { result in
            if result {
                self.stateSignup = .SUCCESS
                UserDefaults.standard.set(user.name, forKey: "Name")
                UserDefaults.standard.set(user.email, forKey: "Email")
                UserDefaults.standard.set(user.picture, forKey: "ProfilePictureUrl")
                UserDefaults.standard.set(user.userToken, forKey: "FCMToken")
                self.isPresentedHomeTabView = true
            }else{
                self.stateSignup = .FAILED
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
    case UNABLE_TO_UPLOAD_PICTURE

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
        case .USER_EXIST:
            return "User exist"
        case .UNABLE_TO_UPLOAD_PICTURE:
            return "Unable to upload"
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
        case .UNABLE_TO_UPLOAD_PICTURE:
            return "Unable to upload profile picture please try again"
        case .USER_EXIST:
            return "This email already exist, please use an other email"
        }
    }
}
