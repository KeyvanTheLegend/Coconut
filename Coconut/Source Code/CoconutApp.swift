//
//  CoconutApp.swift
//  Coconut
//
//  Created by sh on 8/8/21.
//

import SwiftUI
import Firebase

@main
struct CoconutApp: App {
    init() {
        FirebaseApp.configure()
        globalConfigure()
    }
    var body: some Scene {
        WindowGroup {
            /// user is signed in
            if UserDefaults.standard.string(forKey: "Email") != nil {
                HomeView()
            }
            else{
                SignInView()
            }
        }
    }
    private func globalConfigure(){
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
          .tintColor = UIColor(Color("AccentColor"))
    }
}
