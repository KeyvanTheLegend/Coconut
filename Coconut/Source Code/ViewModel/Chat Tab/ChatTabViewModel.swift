//
//  ChatTabViewModel.swift
//  Coconut
//
//  Created by sh on 8/16/21.
//

import Foundation

class ChatTabViewModel : ObservableObject  {
    
    /// - sub ViewModels :
    @Published private(set) var liveChatSessionViewModel : LiveChatSessionViewModel
    @Published private(set) var hasLiveSesssion : Bool = false
    @Published private(set) var conversations : [MessageModel] = []

    
    init() {
        liveChatSessionViewModel = LiveChatSessionViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hasLiveSesssion = true
        }

//        DatabaseManager.shared.createConversation(with: "Keyvan-ygh1-gmail-com", and: "Tara-gmail-com")
    }
    func getConversations(){
    }
}
