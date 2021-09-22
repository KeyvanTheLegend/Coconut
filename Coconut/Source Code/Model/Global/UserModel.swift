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

enum Emotion : String {
    case SMILING = "Smiling"
    case ANGRY = "Angry"
    case SAD = "Sad"
    case WINK = "Winked"
    case SHOCKED = "Shocked"
    case TONGUE_OUT = "Showing tongue"
    case KISS = "Kissing you"

    case UNDEFIND = ""
    
    var emoji :String {
        switch self {

        case .SMILING:
            return "😁"
        case .ANGRY:
            return "😠"
        case .SAD:
            return "☹️"
        case .WINK:
            return "😉"
        case .SHOCKED:
            return "😮"
        case .KISS:
            return "😚"
        case .TONGUE_OUT:
            return "👅"
        case .UNDEFIND:
            return ""

        }
    }
}
