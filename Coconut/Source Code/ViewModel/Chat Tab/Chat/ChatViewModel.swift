//
//  ChatViewModel.swift
//  Coconut
//
//  Created by sh on 8/26/21.
//

import Foundation


class ChatViewModel : ObservableObject  {
    
    /// - sub ViewModels :
    @Published var messages : [MessageModel] = []
    @Published var conversationId : String? = nil
    @Published var user : UserModel? = nil

    
    init(){

    }
    func setConverationId(convesationId : String?){
        guard self.conversationId == nil else {
            return	
        }
        print(conversationId)
        if let convesationId = convesationId {
            self.conversationId = convesationId
            print("SETTING CONVERSATION ID \(convesationId)")
//            DatabaseManager.shared.getMessagesForConversation(conversationId: convesationId) { result in
//                print("SET CONVERSATION : OBSERVIONG CONVERSATION = \(convesationId) + Message is \(result)")
//                self.messages = result
//            }
            DatabaseManager.shared.observeMessagesForConversation(conversationId: convesationId) { message in
                self.messages += message
            }
        }
    }
    func setUser(user : UserModel?){
        if let user = user {
            self.user = user
            if let conversationId = user.sharedConversastion {
                setConverationId(convesationId: conversationId)
                return
            }
            let conversationId = conversationIdIfExsit(with: user)
            print("user is set \(conversationId)")

            setConverationId(convesationId: conversationId)
        }
    }
    
    private func conversationIdIfExsit(with otherUser : UserModel) ->String?{
        guard let userEmail = UserDefaults.standard.string(forKey: "Email") else {return nil}
        for conversation in otherUser.conversation {
            if conversation.email ==  userEmail {
                return conversation.conversationId
            }
            continue
        }
        return nil
    }
    func sendMessage (message:String){
        print("Sending MEssage ConversationID is \(conversationId)")
        let email = UserDefaults.standard.string(forKey: "Email")!
        guard let me = user else {
            return
        }
        
        let otherPerson = UserModel(name: UserDefaults.standard.string(forKey: "Name")!, email: UserDefaults.standard.string(forKey: "Email")!, picture: UserDefaults.standard.string(forKey: "ProfilePictureUrl")!)
        let message = MessageModel(id:UUID(),text: message, senderEmail: email, sentDate: Date())
        if let conversationId = conversationId {
            //send message
            DatabaseManager.shared.sendMessage(conversationId: conversationId,message: message)
            
        }else {
            // create conversation with message
            DatabaseManager.shared.createConversation(with: otherPerson, and: me, message: message) { ID in
                print("Created ConversationId ConversationID is \(ID)")

                self.conversationId = ID
                DatabaseManager.shared.getMessagesForConversation(conversationId: ID) { result in
                    print("OBSERVIONG CONVERSATION = \(ID) + Message is \(result)")
                    self.messages = result
                }
                DatabaseManager.shared.observeMessagesForConversation(conversationId: ID) { message in
                    self.messages += message
                }
	

            }
        }
        
        
    }
}

