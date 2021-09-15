//
//  UserModel.swift
//  Coconut
//
//  Created by sh on 8/24/21.
//

import Foundation

struct UserModel : Identifiable , Codable {
    var id: UUID = UUID()

    let name : String
    let email : String
    var picture : String = ""
    var userToken : String = ""
    var pictureFileName : String {
        return email.safeString() + "\(Date())" + ".png"
    }
    var conversation : [ConversationModel] = []
    var sharedConversastion : String? = nil

    enum CodingKeys : String, CodingKey {
        case name
        case email
        case picture
        case userToken
    }

}
