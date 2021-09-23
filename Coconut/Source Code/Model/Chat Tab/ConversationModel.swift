//
//  ConversationModel.swift
//  Coconut
//
//  Created by sh on 8/30/21.
//

import Foundation

struct ConversationModel : Identifiable , Codable {
    
    var userToken : String  = ""
    let name : String
    let email : String
    var picture : String = ""
    let conversationId : String
    var unreadMessageCount : Int? = 0
    var last_edited : Double? = 0.0
    
    var id: UUID {
        UUID()
    }
    
}
