//
//  ChatViewModel.swift
//  Coconut
//
//  Created by sh on 8/26/21.
//

import Foundation


class ChatViewModel : ObservableObject  {
    
    /// - sub ViewModels :
    @Published private(set) var messages : [MessageModel] = []
    
    init(){
        DatabaseManager.shared.getMessagesForConversation { messages in
            self.messages.append(messages.first!)
        }
    }
    
    func sendMessage (message:String){
        let email = UserDefaults.standard.string(forKey: "Email")!

        let message = MessageModel(id: UUID(), text: message, senderEmail: email, sentDate: Date())
        DatabaseManager.shared.sendMessage(message: message)

    }
}

