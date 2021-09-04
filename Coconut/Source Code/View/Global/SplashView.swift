//
//  SplashView.swift
//  Coconut
//
//  Created by sh on 9/5/21.
//

import SwiftUI

struct SplashView: View {
    @StateObject var loginState = LoginState()
    var body: some View {
        NavigationView {
        SignInView()
            .opacity(loginState.isLogin ? 0:1)
            .fullScreenCover(isPresented: $loginState.isLogin, content: {
            HomeView()

        })
        }
        .environmentObject(loginState)
        .background(Color.background.ignoresSafeArea())
        .onAppear(perform: {
            if UserDefaults.standard.string(forKey: "Email") == nil {
                loginState.isLogin = false
            }
            else {loginState.isLogin = true}
        })

    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
class LoginState: ObservableObject {
    @Published var isLogin : Bool = false
}

