//
//  CoconutApp.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/8/21.
//

import SwiftUI

@main
struct CoconutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var globalObject = GlobalObjects()
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
            .tintColor = UIColor(Color("AccentColor"))
    }
    
    var body: some Scene {
        WindowGroup {
            /// user is signed in
            SplashView()
                .environmentObject(globalObject)
        }
    }
}
