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
            DatabaseManager.shared.getAllConversations(for: userEmail.safeString()) { [weak self] conversations in
                self?.conversations = conversations}
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
