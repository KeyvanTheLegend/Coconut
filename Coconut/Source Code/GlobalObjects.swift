//
//  GlobalObjects.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 9/9/21.
//

import Foundation

class GlobalObjects: ObservableObject {
    /// user signin state
    @Published  var isSignedIn : Bool = false
    
    init(){
        update()
    }
    
    func update(){
        guard
            UserDefaults.standard.string(forKey: "Email") != nil,
            UserDefaults.standard.string(forKey: "Email") != "" else {
            self.isSignedIn = false
            return
        }
        self.isSignedIn = true
    }
}
