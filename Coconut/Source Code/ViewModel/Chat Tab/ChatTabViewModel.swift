//
//  ChatTabViewModel.swift
//  Coconut
//
//  Created by sh on 8/16/21.
//

import Foundation

class ChatTabViewModel : ObservableObject  {
    
//    @Published private(set) var liveChatSessionViewModel : LiveChatSessionViewModel
//    @Published private(set) var hasLiveSesssion : Bool = false
    @Published private(set) var conversations : [ConversationModel] = []

    /// get all user conversations and start observing new ones
    func getAllConversations(){
        guard let userEmail = UserDefaults.standard.string(forKey: "Email") else { return }
            DatabaseManager.shared.getAllConversations(for: userEmail.safeString()) { conversations in
                self.conversations = conversations}
    }
}
