//
//  ChatViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/26/21.
//

import Foundation


class ChatViewModel : ObservableObject  {
    
    /// - sub ViewModels :
    @Published var messages : [MessageModel] = []
    private(set) var conversationID : String? = nil
    private(set) var otherUser : UserModel? = nil
    
    var userEmail : String? {
        return UserDefaults.standard.string(forKey: "Email")!
    }
    
    init(){

    }
    /// set shared conversationID
    /// - Parameter convesationID: shared conversationID if exist
    func setConverationID(convesationID : String?){
        guard let convesationID = convesationID else {
            print("CONVERSATION ID DOUS NOT EXIT")
            return
        }
        self.conversationID = convesationID
        DatabaseManager.shared.observeMessagesForConversation(conversationId: convesationID) { message in
            print("HI 3\(message)")
            self.messages += message
        }
    }
    /// set otherUser in viewModel
    /// - Parameter user: otherUser
    func setOtherUser(user : UserModel?){
        print("IH CALLED \(user)")
        guard let otherUser = user else {
            print("USER DOS NOT EXIT")
            return
        }
        self.otherUser = otherUser
        // if shared conversation id exist , no need to check for shared conversation
        if let sharedConversationId = otherUser.sharedConversastion {
            print("HI shared is \(sharedConversationId)")
            setConverationID(convesationID: sharedConversationId)
        }else {
            setConverationID(convesationID: conversationIDIfExsit(with: otherUser))
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
        print(UserDefaults.standard.string(forKey: "Email"))
        print(UserDefaults.standard.string(forKey: "Name"))
        print(UserDefaults.standard.string(forKey: "FCMToken"))
        print(UserDefaults.standard.string(forKey: "ProfilePictureUrl"))
        print("OTHER USER IS \(otherUser)")
        
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
            DatabaseManager.shared.createConversation(with: otherUser, and: user, message: message) { conversationID in
                print("CREATED \(conversationID)")
                
                self.conversationID = conversationID
                self.observeMessagesForConversation(with: conversationID)
                self.getMessagesForConversation(with: conversationID)

            }
        }
    }
    /// start observing for new messages
    /// - Parameter conversationID: conversationID
    private func observeMessagesForConversation(with conversationID : String){
        DatabaseManager.shared.observeMessagesForConversation(conversationId: conversationID) { message in
            print("HI \(message)")
            self.messages += message
        }
    }
    /// get all messages for conversation **ONCE**
    /// - Parameter conversationID: conversationID
    private func getMessagesForConversation(with conversationID : String){
        DatabaseManager.shared.getMessagesForConversation(conversationId: conversationID) { messages in
            print("HI MESSAGES IS \(messages)")
            DispatchQueue.main.async {
                self.messages = messages

            }
        }
    }
}

