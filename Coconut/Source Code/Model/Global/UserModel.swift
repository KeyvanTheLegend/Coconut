//
//  UserModel.swift
//  Coconut
//
//  Created by sh on 8/24/21.
//

import Foundation

struct UserModel : Identifiable , Codable {

    let name : String
    let email : String
    var picture : String = ""
    var userToken : String = ""

    var safeEmail : String {
        return email.safeString()
    }
    var pictureFileName : String {
        return safeEmail + "\(Date())" + ".png"
    }
    
    var id: UUID {
        UUID()
    }
    enum CodingKeys : String, CodingKey {
        case name
        case email
        case picture
        case userToken
    }
    var conversation : [ConversationModel] = []
    
    var sharedConversastion : String? = nil


}
