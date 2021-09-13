//
//  SplashView.swift
//  Coconut
//
//  Created by sh on 9/8/21.
//

import SwiftUI

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var session : Session
    
    init (){
        setNavBarAppearence(to: .clear)
    }
    
    var body: some View {
        VStack{
            SignInView()
                .opacity(session.isSignedIn ? 0:1)
        }
        .background(Color.background.ignoresSafeArea())
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
