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
    func insertUser(user : UserModel ,compeltion : @escaping ((Bool)->Void)) {
        database.child(user.safeEmail).setValue([
            "name":user.name,
            "picture":user.picture,
            "email":user.email
        ]) { error, _ in
            guard error == nil else {return compeltion(false)}
            compeltion(true)
        }
    }
    func getUser(withEmail safeEmail: String ,compeltion : @escaping ((UserModel)->Void)) {
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String:Any] else {return}
            let decoder = JSONDecoder()
            let jsonData = try! JSONSerialization.data(withJSONObject:value)
            let x = try! decoder.decode(UserModel.self, from: jsonData)
            compeltion(x)
        })
        
    }
    func searchUser(withText text: String ,compeltion : @escaping (([UserModel])->Void)) {
        database.queryOrdered(byChild: "name").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").observeSingleEvent(of: .value, with: { data in
            guard let users = data.value as? [String:Any] else {print("FUCK");return}
            print(users)
            let decoder = JSONDecoder()
            var usersModel : [UserModel] = []

            for user in users{
                print(user)
                let jsonData = try! JSONSerialization.data(withJSONObject:user.value)
                var userModel = try! decoder.decode(UserModel.self, from: jsonData)
                if let userDic = user.value as? [String:Any] {
                    if let conversation = userDic["conversations"] as? [String:Any] {
                    var conversationsModel : [ConversationModel] = []
                    for conversation in conversation {
                        let jsonData = try! JSONSerialization.data(withJSONObject: conversation.value)
                        let conversation = try! decoder.decode(ConversationModel.self, from: jsonData)
                        conversationsModel.append(conversation)
                    }
                    
                    userModel.conversation = conversationsModel
                    }
                }

                usersModel.append(userModel)
                
                print(userModel)
                
            }
            compeltion(usersModel)
        })
    }
    
}
// MARK: - Messages Manager
extension DatabaseManager {
    
    func getAllConversations(for safeEmail : String , compelition : @escaping ([ConversationModel])->Void){
        database.child(safeEmail).child("conversations").observe(.value) { snapshot in
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
    
    func createConversation(with me : UserModel , and otherPerson : UserModel , message : MessageModel , compelition : @escaping (String) -> Void ){
        let conversationId = database.childByAutoId()
        let json = message.dictionary
        let conversationForMe = ConversationModel(name: me.name, email: me.email, picture: me.picture, conversationId: conversationId.key!)
        let conversationForOtherPerson = ConversationModel(name: otherPerson.name, email: otherPerson.email, picture: otherPerson.picture, conversationId: conversationId.key!)
        database.child(conversationId.key!).child("lastMessage").childByAutoId().setValue(json!)
        database.child(conversationId.key!).child("messages").childByAutoId().setValue(json!)
        database.child(me.safeEmail).child("conversations").childByAutoId().setValue(conversationForOtherPerson.dictionary!)
        database.child(otherPerson.safeEmail).child("conversations").childByAutoId().setValue(conversationForMe.dictionary!) { err, _ in
            
            compelition(conversationId.key!)
        }
    }
    func checkConversationExist(for user : UserModel , with otherUser : UserModel , compelition : @escaping (String?)->Void)
    {
        database.child(user.safeEmail).child("conversations").observeSingleEvent(of: .value) { snapshot in
            guard let conversations = snapshot.value as? [String:Any] else {
                compelition(nil)
                return
            }
            let decoder = JSONDecoder()
            for conversation in conversations {
                let jsonData = try! JSONSerialization.data(withJSONObject:conversation.value)
                let conversationModel = try! decoder.decode(ConversationModel.self, from: jsonData)
                if conversationModel.email == otherUser.email {
                    print("FOUNDD")
                    compelition(conversationModel.conversationId)
                    break
                }
            
            }
            compelition(nil)

        }
    }	
    
    func getMessagesForConversation(conversationId id :String,compelition : @escaping ([MessageModel]) -> Void ) {
        database.child(id).child("messages").observeSingleEvent(of: .value) { snapshot in
            var messages : [MessageModel] = []
            guard let value = snapshot.value as? [String:Any] else {return}
            let decoder = JSONDecoder()
            for key in value.keys {
                let jsonData = try! JSONSerialization.data(withJSONObject:value[key])
                let x = try! decoder.decode(MessageModel.self, from: jsonData)
                messages.append(x)
            }

            print("SINGLE OBSERVED MESSAGES IS : \(messages)")

            compelition(messages)

            
        }
    }
    func observeMessagesForConversation(conversationId id :String,compelition : @escaping ([MessageModel]) -> Void ) {
        database.child(id).child("messages").observe(.childAdded) { snapshot in
            var messages : [MessageModel] = []
            guard let value = snapshot.value as? [String:Any] else {return}
            let decoder = JSONDecoder()
            let jsonData = try! JSONSerialization.data(withJSONObject:value)
            let x = try! decoder.decode(MessageModel.self, from: jsonData)
            messages.append(x)
            
            
            print("SINGLE OBSERVED MESSAGES IS : \(messages) + with id : \(x.id)")
            
            compelition(messages)
            
            
        }
    }
    
    func sendMessage(conversationId :String,message : MessageModel){
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
