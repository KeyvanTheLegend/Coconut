//
//  PersonImageNameStatusViewModel.swift
//  Coconut
//
//  Created by Keyvan on 8/16/21.
//

import Foundation

class PersonImageNameStatusViewModel : ObservableObject{
    
    /// - Parameter duration : Chat duration text
    @Published var profileImage : String = "- - - - -"
    /// - Parameter messagesCount : How many messages sent or received since the beginning of the chat
    @Published var name : String = "- - - - - -"
    /// - Parameter smilesCount : How many smiles sent or received since the beginning of the chat
    @Published var statusMessage : String = "- - - - - - -"

    init(){
        
    }
    func setProfileImage(image:String){
        self.profileImage = image
    }
    func setName(name:String){
        self.name = name
    }
    func setStatusMessage(statusMessage:String){
        self.statusMessage = statusMessage
    }
}
