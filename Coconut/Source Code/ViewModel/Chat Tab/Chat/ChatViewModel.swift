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
    @Published private(set) var conversationID : String? = nil
    @Published private(set) var user : UserModel? = nil

    
    init(){

    }
    /// set shared conversationID
    /// - Parameter convesationID: shared conversationID if exist
    func setConverationID(convesationID : String?){
        guard self.conversationID == nil else {
            return	
        }
        guard let convesationID = convesationID else {
            return
        }
        self.conversationID = convesationID
        DatabaseManager.shared.observeMessagesForConversation(conversationId: convesationID) { message in
            self.messages += message
        }
    }
    /// set otherUser in viewModel
    /// - Parameter user: otherUser
    func setUser(user : UserModel?){
        guard let user = user else {
            return
        }
        self.user = user
        // if shared conversation id exist , no need to check for shared conversation
        if let sharedConversationId = user.sharedConversastion {
            setConverationID(convesationID: sharedConversationId)
        }else {
            setConverationID(convesationID: conversationIDIfExsit(with: user))
        }
    }
    
    /// check if user has a existing conversation (shared) with other user
    /// - Parameter otherUser: other user
    /// - Returns: shared **conversationID** if exist
    private func conversationIDIfExsit(with otherUser : UserModel) ->String?{
        guard let userEmail = UserDefaults.standard.string(forKey: "Email") else {return nil}
        for conversation in otherUser.conversation {
            if conversation.email ==  userEmail {
                return conversation.conversationId
            }
            continue
        }
        return nil
    }
    
    /// send message to other user
    /// - Parameters:
    ///   - message: message text
    ///   - otherUser: user to send message to
    func sendMessage(messageText:String,to otherUser : UserModel?){
        guard
            let userEmail = UserDefaults.standard.string(forKey: "Email"),
            let userName = UserDefaults.standard.string(forKey: "Name"),
            let userPicture = UserDefaults.standard.string(forKey: "ProfilePictureUrl"),
            let otherUser = otherUser else {
            return
        }
        let user = UserModel(name: userName, email: userEmail, picture: userPicture)
        let message = MessageModel(id:UUID(),text: messageText, senderEmail: userEmail, sentDate: Date())
    
        if let conversationId = conversationID {
            DatabaseManager.shared.sendMessage(conversationId: conversationId,message: message)
        }else {
            // create conversation with message
            DatabaseManager.shared.createConversation(with: otherUser, and: user, message: message) { conversationID in
                self.conversationID = conversationID
                self.getMessagesForConversation(with: conversationID)
                self.observeMessagesForConversation(with: conversationID)
            }
        }
    }
    /// start observing for new messages
    /// - Parameter conversationID: conversationID
    private func observeMessagesForConversation(with conversationID : String){
        DatabaseManager.shared.observeMessagesForConversation(conversationId: conversationID) { message in
            self.messages += message
        }
    }
    /// get all messages for conversation **ONCE**
    /// - Parameter conversationID: conversationID
    private func getMessagesForConversation(with conversationID : String){
        DatabaseManager.shared.getMessagesForConversation(conversationId: conversationID) { messages in
            self.messages = messages
        }
    }
}

