//
//  MessageModel.swift
//  Coconut
//
//  Created by sh on 8/26/21.
//

import Foundation

struct MessageModel : Hashable,Identifiable , Codable {
    var id: String = ""
    var internalId : UUID = UUID()
    let text : String
    let senderEmail : String
    let sentDate : Date
    var isRead = true
    var isPhoto : Bool? = false
//    
//    
//    enum CodingKeys : String, CodingKey {
//        case id
//        case text
//        case senderEmail
//        case sentDate
//        case isRead 
//    }
}
enum MessageType : Int , Codable {
    case text = 1
    case photo = 2
}
