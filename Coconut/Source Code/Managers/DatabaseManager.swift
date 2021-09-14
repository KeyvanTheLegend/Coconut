//
//  DatabaseManager.swift
//  Coconut
//
//  Created by sh on 8/26/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}
// MARK: - Account Manager
extension DatabaseManager {
    /// insert user to firebase database with user **SAFE EMAIL** as identifying key
    /// - Parameters:
    ///   - user: user data model
    ///   - compeltion: return true if success
    func insertUser(
        user : UserModel,
        compeltion : @escaping ((Bool)->Void)) {
        database.child(user.email.safeString()).setValue([
            "name":user.name,
            "picture":user.picture,
            "email":user.email,
            "userToken":user.userToken
        ]) { error, _ in
            guard error == nil else {return compeltion(false)}
            compeltion(true)
        }
    }
    
    /// fetch user data from database
    /// - Parameters:
    ///   - email: email is used as user primary key
    ///   - compeltion: compeltion
    /// - TODO: change compeltion to Result (UserModel,Error)
    func getUser(
        withEmail email: String,
        compeltion : @escaping ((UserModel)->Void)) {
        database.child(email.safeString()).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                print("ERROR")
                return
            }
            let decoder = JSONDecoder()
            let jsonData = try! JSONSerialization.data(withJSONObject:value)
            guard let user = try? decoder.decode(UserModel.self, from: jsonData) else{
                print("ERROR DECODING")
                return
            }
            compeltion(user)
        })
    }
    
    /// update User Token
    /// - Parameters:
    ///   - email: user email
    ///   - token: user token
    func updateUserToken(
        withEmail email: String,
        to token : String) {
        database.child(email.safeString()).child("userToken").setValue(token)
    }
    
    /// update user profile picture url
    /// - Parameters:
    ///   - email: user email
    ///   - url: profile picture url
    func updateProfilePicture(
        forEmail email: String,
        withImageUrl url : String){
        database.child(email.safeString()).child("picture").setValue(url)
    }
    
    /// - TODO: Change compeltion to result , Clean json parsing
    /// - Parameters:
    ///   - text: search text
    ///   - compeltion: serach result
    func searchUser(
        withText text: String,
        compeltion : @escaping (([UserModel])->Void)) {
        DispatchQueue.global().async { [weak self] in
            self?.database.queryOrdered(byChild: "name").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").observeSingleEvent(of: .value, with: { data in
                guard let users = data.value as? [String:Any] else {
                    compeltion([])
                    return
                }
                let decoder = JSONDecoder()
                
                var usersModel : [UserModel] = []
    
                for user in users {
                    let jsonData = try! JSONSerialization.data(withJSONObject:user.value)
                    var userModel = try! decoder.decode(UserModel.self, from: jsonData)
                    if let userDic = user.value as? [String:Any] {
                        if let conversation = userDic["conversations"] as? [String:Any] {
                            for conversation in conversation {
                                let jsonData = try! JSONSerialization.data(withJSONObject: conversation.value)
                                userModel.conversation.append(try! decoder.decode(ConversationModel.self, from: jsonData))
                            }
                        }
                    }
                    usersModel.append(userModel)
                }
                compeltion(usersModel)
            })
        }
    }
    /// get blocked Emails
    /// - Parameters:
    ///   - email: user email
    ///   - compelition: result
    func getBlockedEmails(
        for email:String,
        compelition : @escaping ([String]) -> Void ) {
        database.child(email.safeString()).child("blocked").observe(.value) { snapshot in
            var blockedEmails : [String] = []
            guard let value = snapshot.value as? [String:Any] else {return}
            blockedEmails = value.compactMap({ values in
                return values.value as? String
            })
            compelition(blockedEmails)
        }
    }
    /// block a user
    /// - Parameters:
    ///   - email: email to block
    ///   - userEmail: user who i blocking
    ///   - compelition: result
    func blockUser(
        with email : String,
        for userEmail : String,
        compelition : @escaping (Bool) -> Void ) {
        print(email.safeString())
        print(userEmail.safeString())
        database.child(userEmail.safeString()).child("blocked").childByAutoId().setValue(email.safeString())
    }
    /// report a user
    /// - Parameters:
    ///   - email: email to be reported
    ///   - compelition: result
    func reportUser(
        with email : String,
        compelition : @escaping (Bool) -> Void ) {
        database.child("report").childByAutoId().setValue(email.safeString())
        compelition(true)
    }
}


// MARK: - Messages Manager
extension DatabaseManager {
    
    /// observe user conversations
    /// - Parameters:
    ///   - Email: user email to observe
    ///   - compelition: result
    func observeUserConversations(
        with email : String,
        compelition : @escaping ([ConversationModel])->Void) {
        database.child(email).child("conversations").observe(.value) { snapshot in
            var conversationsModel: [ConversationModel] = []
            guard let conversations = snapshot.value as? [String:Any] else {
                compelition(conversationsModel)
                return
            }
            let decoder = JSONDecoder()
            for conversation in conversations {
                let jsonData = try! JSONSerialization.data(withJSONObject:conversation.value)
                let conversationModel = try! decoder.decode(ConversationModel.self, from: jsonData)
                conversationsModel.append(conversationModel)
            }
            compelition(conversationsModel)
        }
    }
    
    /// create conversaion
    /// - Parameters:
    ///   - me: user
    ///   - otherPerson: other user in conversation
    ///   - message: first  message
    ///   - compelition: result
    func createConversation(
        with me : UserModel,
        and otherPerson : UserModel,
        message : MessageModel,
        compelition : @escaping (String) -> Void ) {
        let conversationId = database.childByAutoId()
        let json = message.dictionary
        let conversationForMe = ConversationModel(userToken : me.userToken,name: me.name, email: me.email, picture: me.picture, conversationId: conversationId.key!)
        let conversationForOtherPerson = ConversationModel(userToken : otherPerson.userToken ,name: otherPerson.name, email: otherPerson.email, picture: otherPerson.picture, conversationId: conversationId.key!)
        database.child(conversationId.key!).child("lastMessage").childByAutoId().setValue(json!)
        database.child(conversationId.key!).child("messages").childByAutoId().setValue(json!)
        
        database.child(me.safeEmail).child("conversations").childByAutoId().setValue(conversationForOtherPerson.dictionary!)
        database.child(otherPerson.safeEmail).child("conversations").childByAutoId().setValue(conversationForMe.dictionary!) { err, _ in
            
            compelition(conversationId.key!)
        }
    }
    
    /// get messages of a conversation
    /// - Parameters:
    ///   - id: conversation id
    ///   - compelition: result
    func getMessagesForConversation(
        conversationId id :String,
        compelition : @escaping ([MessageModel]) -> Void ) {
        database.child(id).child("messages").observeSingleEvent(of: .value) { snapshot in
            var messages : [MessageModel] = []
            guard let value = snapshot.value as? [String:Any] else {return}
            let decoder = JSONDecoder()
            for key in value.keys {
                let jsonData = try! JSONSerialization.data(withJSONObject:value[key]!)
                let x = try! decoder.decode(MessageModel.self, from: jsonData)
                messages.append(x)
            }
            print("SINGLE OBSERVED MESSAGES IS : \(messages)")
            compelition(messages)
        }
    }
    
    /// changes status of user typing in a conversation
    /// - Parameters:
    ///   - email: user email
    ///   - conversationId: conversationId
    ///   - isTyping: true for isTyping false for not typing
    func userIsTyping(
        with email :String,
        in conversationId : String,
        isTyping : Bool) {
        database.child(conversationId).child("\(email.safeString())_typing").setValue(isTyping)
    }
    
    /// observe a email isTyping in conversation
    /// - Parameters:
    ///   - conversationID: conversationID
    ///   - user: user to obeserve
    ///   - compelition: result
    func observeIsTypingInConverstion(
        with conversationID: String,
        for user: String,
        compelition : @escaping (Bool) -> Void){
        database.child(conversationID).child("\(user.safeString())_typing").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? Bool else {
                compelition(false)
                return
            }
            compelition(value)
        })
    }
    
    /// observe messages adding to conversation
    /// - Parameters:
    ///   - id: conversationID
    ///   - compelition: result
    func observeMessagesForConversation(
        conversationId id :String,
        compelition : @escaping ([MessageModel]) -> Void ) {
        database.child(id).child("messages").observe(.childAdded) { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                compelition([])
                return
            }
            var messages : [MessageModel] = []
            let decoder = JSONDecoder()
            guard
                let jsonData = try? JSONSerialization.data(withJSONObject:value),
                let message = try? decoder.decode(MessageModel.self, from: jsonData) else {
                compelition([])
                return
            }
            messages.append(message)
            compelition(messages)
        }
    }
    
    /// send  message to a conversation    
    /// - Parameters:
    ///   - conversationId: conversationID
    ///   - message: message
    func sendMessage(
        conversationId:String
        ,message : MessageModel) {
        let json = message.dictionary
        database.child(conversationId).child("messages").childByAutoId().setValue(json!)
    }    
}
// MARK: - Enums
///  Network request state such as firebase database changes
enum NetworkRequestState {
    case UNDEFINED
    case LOADING
    case FAILED
    case SUCCESS
    
    func isLoading() -> Bool {
        return self == .LOADING
    }
}



//func checkConversationExist(for user : UserModel , with otherUser : UserModel , compelition : @escaping (String?)->Void)
//{
//    database.child(user.safeEmail).child("conversations").observeSingleEvent(of: .value) { snapshot in
//        guard let conversations = snapshot.value as? [String:Any] else {
//            compelition(nil)
//            return
//        }
//        let decoder = JSONDecoder()
//        for conversation in conversations {
//            let jsonData = try! JSONSerialization.data(withJSONObject:conversation.value)
//            let conversationModel = try! decoder.decode(ConversationModel.self, from: jsonData)
//            if conversationModel.email == otherUser.email {
//                print("FOUNDD")
//                compelition(conversationModel.conversationId)
//                break
//            }
//
//        }
//        compelition(nil)
//
//    }
//}
//
//
//    func removeMessageObserver(for conversationId : String ){
//
//        database.child(conversationId).child("messages").removeAllObservers()
//    }
