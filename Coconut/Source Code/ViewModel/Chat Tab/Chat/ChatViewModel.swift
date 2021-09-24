//
//  ChatViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/26/21.
//

import Foundation
import ARKit
import UIKit

class ChatViewModel : NSObject,ObservableObject , ARSCNViewDelegate {
    
    /// - sub ViewModels :
    @Published private(set) var messages : [MessageModel] = []
    @Published private(set) var isTyping : Bool = false
    private(set) var conversationID : String? = nil
    private(set) var otherUser : UserModel? = nil
    @Published private(set) var otherUserEmpotion : Emotion = .UNDEFIND
    private(set) var userEmotion : Emotion = .UNDEFIND

    var encodedSubscribedMyModels : Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(conversationID)
    }
    
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
            self?.markRedaAllMessages()
            self?.observeChildChanges()

        }
    }
    func observeChildChanges(){
        for message in messages {
            if message.senderEmail == Session.shared.user?.email ?? "" && !message.isRead {
                DatabaseManager.shared.observeReadChanges(inConversation: conversationID ?? "", messageID: message.id) { messageID in
                    DispatchQueue.main.async {
                        guard let index = self.messages.firstIndex(where: { message in
                            message.id == messageID
                        })else {return}
                        self.messages[index].isRead = true
                    }
                }
            }
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
    func sendPicture(picture : UIImage , to conversationID : String){
        StorageManager.shared.uploadProfilePicture(with: picture, fileName: "\(conversationID)_\(Date().timeIntervalSince1970)") { result in
            switch result {
            case .failure(_):
            break
            case .success(let pictureUrl):
                self.sendMessage(messageText: pictureUrl, to: self.otherUser,type: .photo)
                break
            }
        }
    }
    
    
    func markAsReadAllMessages(){
        guard let conversationID = conversationID else{return}
        guard let userEmail = Session.shared.user?.email else {return}
        DatabaseManager.shared.clearNotReadMessagesInConversation(forUser: userEmail.safeString(),conversationID: conversationID)

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
    func sendMessage(messageText:String,to otherUser : UserModel? , type : MessageType){

        guard
            let userEmail = UserDefaults.standard.string(forKey: "Email"),
            let userName = UserDefaults.standard.string(forKey: "Name"),
            let otherUser = otherUser else {
            return
        }
        
        let userPicture = UserDefaults.standard.string(forKey: "ProfilePictureUrl") ?? ""
        let userToken = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        
        let user = UserModel(
            name: userName,
            email: userEmail,
            picture: userPicture,
            userToken: userToken
        )
        let message = MessageModel(
            text: messageText,
            senderEmail: userEmail,
            sentDate: Date(),
            isRead: false,
            isPhoto: (type == .photo)
        )
        PushNotificationSender.shared.sendPushNotification(to: otherUser.userToken, title: user.name, body: message.text)
        if let conversationId = self.conversationID {
            DatabaseManager.shared.sendMessage(conversationId: conversationId,message: message)
            DatabaseManager.shared.addNotReadMessage(with: otherUser.email.safeString(), to: conversationId)
        }else {
            // create conversation with message
            DatabaseManager.shared.createConversation(with: otherUser, and: user, message: message) { [weak self] conversationID in
                DispatchQueue.main.async{
                    self?.conversationID = conversationID
                    self?.observeMessagesForConversation(with: conversationID)
                    self?.getMessagesForConversation(with: conversationID)

                }
                DatabaseManager.shared.addNotReadMessage(with: otherUser.email.safeString(), to: conversationID)
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
    /// observe if other user is typing or now
    /// - Parameter conversationID: conversationID
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
    func markRedaAllMessages (){
        guard let userEmail = Session.shared.user?.email else {
            return
        }
        for message in messages {
            if message.senderEmail != userEmail && !message.isRead {
                DatabaseManager.shared.markAsRead(message: message.id, in: conversationID ?? "")
            }
        }
    }
    /// get all messages for conversation **ONCE**
    /// - Parameter conversationID: conversationID
    private func getMessagesForConversation(with conversationID : String){
        DatabaseManager.shared.getMessagesForConversation(conversationId: conversationID) { [weak self] messages in
            DispatchQueue.main.async {
                print("HI MESSAGES IS \(messages)")
                self?.messages = messages
            }
        }
    }
    
    
    private var arView: ARSCNView?
    private var isSmiling = false

    func setARView(_ arView: ARSCNView) {
        self.arView = arView
        
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.delegate = self
        
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let anchor = ARFaceAnchor(anchor: anchor)

        if (anchor.blendShapes[.tongueOut] as! Double > 0.4 ){
           sendEmotion(.TONGUE_OUT)
       }
        else if ( anchor.blendShapes[.mouthPucker] as! Double > 0.45 ) {
            sendEmotion(.KISS)
        }
        else if (
            anchor.blendShapes[.mouthSmileLeft] as? Double ?? 0 > 0.7 ||
                anchor.blendShapes[.mouthSmileRight] as? Double ?? 0 > 0.7 ) {
            sendEmotion(.SMILING)

        } else if (anchor.blendShapes[.eyeBlinkLeft] as! Double >= 0.5 || (anchor.blendShapes[.eyeBlinkRight] as! Double > 0.5)){
            sendEmotion(.WINK)
        } else if (anchor.blendShapes[.browDownLeft] as! Double >= 0.4 || anchor.blendShapes[.browDownRight] as! Double >= 0.4 &&
                    (0.05 >= anchor.blendShapes[.eyeBlinkLeft] as! Double   && (  0.05 >= anchor.blendShapes[.eyeBlinkRight] as! Double ))){
            sendEmotion(.ANGRY)
        } else if (anchor.blendShapes[.jawOpen] as! Double >= 0.5 && (anchor.blendShapes[.browInnerUp] as! Double > 0.1)){
            sendEmotion(.SHOCKED)
        }
        else {
            sendEmotion(.UNDEFIND)
        }
        
    }
    func sendEmotion(_ empotion : Emotion){
        if self.userEmotion != empotion{
            self.userEmotion = empotion
            print("HI IM HERE \(empotion)")
            print("userEmotion : \(userEmotion)")
            print("emotion : \(empotion)")

            guard let converastionID = conversationID else{return}
            guard let userEmail = Session.shared.user?.email  else {
                return
            }
            DatabaseManager.shared.setUserEmotionForConversation(
                conversationID: converastionID,
                for: userEmail,
                emotion: empotion)
                print("HI Updated Emption  \(empotion)")

            }
        
    }
    func pauseAR(){
        arView?.session.pause()
    }
    func observeOtherUserEmpotion(){
        guard let conversationID = self.conversationID ,
              let otherUserEmail = self.otherUser?.email else {
            return
        }
        DatabaseManager.shared.observeUserEmotionInConversation(conversationID: conversationID, for: otherUserEmail.safeString()) { empotion in
            DispatchQueue.main.async {
                print("RECIVED EMPTION \(empotion)")
                self.otherUserEmpotion = empotion
            }
        }
    }
}




//    func removeObserver(){
//        DatabaseManager.shared.removeMessageObserver(for: self.conversationID ?? "")
//    }

