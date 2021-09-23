//
//  ChatTabViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/16/21.
//

import Foundation

class ChatTabViewModel : ObservableObject  {

    @Published private(set) var conversations : [ConversationModel] = []
    @Published private(set) var blockedEmails : [String] = []
    @Published var selectedUser : UserModel?
    
    /// get all user conversations and start observing new ones
    func getAllConversations(){
        guard let userEmail = Session.shared.user?.email else { return }
        DatabaseManager.shared.observeUserConversations(with: userEmail.safeString()) { [weak self] conversations in
            DispatchQueue.main.async {
                self?.conversations = conversations
                _ = conversations.map{
                    self?.fetchUserProfilePictureForConversation(email: $0.email)
                    self?.fetchConversationUnreadMesssages(userEmail: userEmail, conversationID: $0.conversationId)
                }
            }
        }
    }
    func fetchUserProfilePictureForConversation(email : String){
        DatabaseManager.shared.getUserProfilePicture(userEmail: email.safeString()) { result  in
            switch result {
            case .failure(_):
                // modifie error
                break
            case .success(let picture):
                let index = self.conversations.firstIndex{ conversation in
                    return conversation.email == email
                }
                guard let index = index else{return}
                DispatchQueue.main.async {
                    self.conversations[index].picture = picture
                }
            break
            }
        }
    }
    func fetchConversationUnreadMesssages(userEmail : String , conversationID : String){
        DatabaseManager.shared.getConversationUnReadMessageCount(forUser: userEmail.safeString(),in: conversationID) { unreadMessage in
            let index = self.conversations.firstIndex{ conversation in
                return conversation.conversationId == conversationID
            }
            guard let index = index else{return}
            DispatchQueue.main.async {
                self.conversations[index].unreadMessageCount = unreadMessage
                print("conv unread \(unreadMessage)")
            }
        }
    }
    /// observe user blocklist
    func observeBlockedEmails(){
        guard let userEmail = Session.shared.user?.email else { return }
        DatabaseManager.shared.getBlockedEmails(for: userEmail.safeString()) { blockedEmails in
            DispatchQueue.main.async {
                self.blockedEmails = blockedEmails
            }
        }
    }
    /// selected conversation by user to view chat
    /// - Parameter conversation: conversation
    func setSelectedConversation(conversation : ConversationModel){
         setSelectedUserIn(selectedConversation: conversation)
    }
    
    /// set selected user based on **selected** conversation
    /// - Parameter conversation: selected Conversation
    private func setSelectedUserIn(selectedConversation conversation : ConversationModel ) {
        selectedUser = UserModel(
            name: conversation.name,
            email: conversation.email,
            picture: conversation.picture,
            userToken: conversation.userToken,
            sharedConversastion: conversation.conversationId
        )
    }
    
}
