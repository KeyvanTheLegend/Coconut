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
    init() {FirebaseApp.configure()}
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
