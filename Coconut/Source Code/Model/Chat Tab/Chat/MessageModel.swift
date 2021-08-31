//
//  MessageModel.swift
//  Coconut
//
//  Created by sh on 8/26/21.
//

import Foundation

struct MessageModel : Identifiable , Codable {
    var id: UUID
    let text : String
    let senderEmail : String
    let sentDate : Date
}
