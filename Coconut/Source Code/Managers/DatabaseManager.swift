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
            "name":user.name
        ]) { error, _ in
            guard error == nil else {return compeltion(false)}
            compeltion(true)
        }
    }
}
// MARK: - Messages Manager
extension DatabaseManager {
    
    func getConversations(){
        database.child("test").observe(.value) { snapshot in

            
        }
    }
    
    func createConversation(){
        
    }
    
    func getMessagesForConversation(compelition : @escaping ([MessageModel]) -> Void ) {
        database.child("test").observe(.childAdded) { snapshot in
            var messages : [MessageModel] = []
            guard let value = snapshot.value as? [String:Any] else {return}
            let decoder = JSONDecoder()
            let jsonData = try! JSONSerialization.data(withJSONObject:value)
            let x = try! decoder.decode(MessageModel.self, from: jsonData)

            messages.append(x)
            print(messages)

            compelition(messages)

            
        }
    }
    
    func sendMessage(message : MessageModel){
        let json = message.dictionary
        database.child("test").childByAutoId().setValue(json!)
        
    }
    
    
    
}
extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
