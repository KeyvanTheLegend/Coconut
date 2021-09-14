//
//  Session.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 9/9/21.
//

import Foundation

class Session: ObservableObject {
    
    public static let shared = Session()

    /// user signin state
    @Published  var isSignedIn : Bool = false
    // session signedIn user
    @Published var user : UserModel?
        
    init(){
        update()
    }
    
    /// update Session
    func update(){
        updateUser()
        checkIsUserSignedIn()
    }
    
    /// check if any user is sigenedIn
    private func checkIsUserSignedIn(){
        guard
            UserDefaults.standard.string(forKey: "Email") != nil,
            UserDefaults.standard.string(forKey: "Email") != "" else {
            isSignedIn = false
            return
        }
        isSignedIn = true
    }
    
    /// update session user
    private func updateUser() {
        guard
            let email = UserDefaults.standard.string(forKey: "Email"),
            let name = UserDefaults.standard.string(forKey: "Name"),
            let picture = UserDefaults.standard.string(forKey: "ProfilePictureUrl") else{
            self.user = nil

            return
        }
        guard let userToken = UserDefaults.standard.string(forKey: "FCMToken") else {
           user = UserModel(
                name: name,
                email: email,
                picture : picture
            )
            return
        }
        user =  UserModel(
            name: name,
            email: email, picture: picture,
            userToken: userToken
        )
        return
    }
}
