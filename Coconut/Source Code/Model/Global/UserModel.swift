//
//  UserModel.swift
//  Coconut
//
//  Created by sh on 8/24/21.
//

import Foundation

struct UserModel : Codable {
    let name : String
    let email : String
    var safeEmail : String {
        var safeEmail = email.replacingOccurrences(of: "@", with: "-")
        safeEmail =  safeEmail.replacingOccurrences(of: ".", with: "-")
        return safeEmail
    }
}
