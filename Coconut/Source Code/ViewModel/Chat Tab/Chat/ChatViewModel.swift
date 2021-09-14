//
//  ChatViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/26/21.
//

import Foundation


class ChatViewModel : ObservableObject  {
    
    /// - sub ViewModels :
    @Published private(set) var messages : [MessageModel] = []
    @Published private(set) var isTyping : Bool = false
    private(set) var conversationID : String? = nil
    private(set) var otherUser : UserModel? = nil
    
    let userEmail : String?  = UserDefaults.standard.string(forKey: "Email")!

    /// set shared conversationID
    /// - Parameter convesationID: shared conversationID if exist
    func setConverationID(convesationID : String?){
        guard let convesationID = convesationID else {
            print("CONVERSATION ID DOUS NOT EXIT")
            return
        }
        self.conversationID = convesationID
        DatabaseManager.shared.observeMessagesForConversation(conversationId: convesationID) { [weak self] message in
            self?.messages += message
        }
    }
    /// set otherUser in viewModel
    /// - Parameter user: otherUser
    func setOtherUser(user : UserModel?){
        guard let otherUser = user else {
            print("USER DOS NOT EXIT")
            return
        }
        self.otherUser = otherUser
        // if shared conversation id exist , no need to check for shared conversation
        if let sharedConversationId = otherUser.sharedConversastion {
            print("HI shared is \(sharedConversationId)")
            setConverationID(convesationID: sharedConversationId)
            observeConversationIsTyping(with: sharedConversationId)
        }else {
            setConverationID(convesationID: conversationIDIfExsit(with: otherUser))
        }
    }
    
    /// check if the message is recived or sent
    /// - Parameter message: message
    /// - Returns: true if message is sent
    func isSentMessage(message : MessageModel) -> Bool{
        guard let userEmail = Session.shared.user?.email else {
            return false
        }
        return userEmail == message.senderEmail
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
            let userToken = UserDefaults.standard.string(forKey: "FCMToken"),
            let otherUser = otherUser else {
            print("ERRORRRRR")
            return
        }
        let userPicture = UserDefaults.standard.string(forKey: "ProfilePictureUrl") ?? ""
        let user = UserModel(
            name: userName,
            email: userEmail,
            picture: userPicture,
            userToken: userToken
        )
        let message = MessageModel(
            id:UUID(),
            text: messageText,
            senderEmail: userEmail,
            sentDate: Date()
        )
        print("token is :\(otherUser.userToken)")
        PushNotificationSender.shared.sendPushNotification(to: otherUser.userToken, title: user.name, body: message.text)
        if let conversationId = self.conversationID {
            print("HAVE ID")
            DatabaseManager.shared.sendMessage(conversationId: conversationId,message: message)
        }else {
            // create conversation with message
            DatabaseManager.shared.createConversation(with: otherUser, and: user, message: message) { [weak self] conversationID in
                print("CREATED \(conversationID)")
                
                self?.conversationID = conversationID
                self?.observeMessagesForConversation(with: conversationID)
                self?.getMessagesForConversation(with: conversationID)

            }
        }
    }
    /// start observing for new messages
    /// - Parameter conversationID: conversationID
    private func observeMessagesForConversation(with conversationID : String){
        DatabaseManager.shared.observeMessagesForConversation(conversationId: conversationID) { [weak self] message in
            print("HI \(message)")
            self?.messages += message
        }
    }
    private func observeConversationIsTyping(with conversationID : String){
        guard let otherUserEmail = otherUser?.email else {
            return
        }
        DatabaseManager.shared.observeIsTypingInConverstion(with: conversationID, for:  otherUserEmail.safeString()) { isTyping in
            DispatchQueue.main.async {
                self.isTyping = isTyping
            }
        }


    }
    /// get all messages for conversation **ONCE**
    /// - Parameter conversationID: conversationID
    private func getMessagesForConversation(with conversationID : String){
        DatabaseManager.shared.getMessagesForConversation(conversationId: conversationID) { [weak self] messages in
            print("HI MESSAGES IS \(messages)")
            DispatchQueue.main.async {
                self?.messages = messages

            }
        }
    }
//    func removeObserver(){
//        DatabaseManager.shared.removeMessageObserver(for: self.conversationID ?? "")
//    }
}

