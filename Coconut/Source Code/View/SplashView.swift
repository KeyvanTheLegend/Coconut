//
//  SplashView.swift
//  Coconut
//
//  Created by sh on 9/8/21.
//

import SwiftUI

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var userStatus : UserStatus
    var body: some View {
        NavigationView {
        SignInView()
            .opacity(userStatus.isSignin ? 0:1)
            .fullScreenCover(isPresented: $userStatus.isSignin, content: {
            HomeView()

        })
        }
        .navigationViewStyle(StackNavigationViewStyle())
//        .environmentObject(userStatus)
        .background(Color.background.ignoresSafeArea())
        .onAppear(perform: {
            if UserDefaults.standard.string(forKey: "Email") == nil {
                userStatus.isSignin = false
            }
            else {userStatus.isSignin = true}
        })

    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
