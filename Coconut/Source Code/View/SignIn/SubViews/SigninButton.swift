//
//  SigninButton.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/28/21.
//

import SwiftUI

struct SigninButton : View {
    
    @Binding var email : String
    @Binding var password : String
    
    @ObservedObject var viewModel : SigninViewModel
    
    var body: some View{
        ZStack(alignment: .center){
            /// loading image
            Image(systemName: "circle.dashed")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.white)
                .zIndex(
                    viewModel.stateSignin.isLoading() ? 2:0
                )
                .rotationEffect(
                    viewModel.stateSignin.isLoading() ? Angle(degrees: 360):.zero,
                    anchor: .center
                )
                .animation(
                    viewModel.stateSignin.isLoading() ?
                        .easeIn(duration: 1).repeatForever(autoreverses: false):.linear(duration: 0)
                )
                .opacity(
                    viewModel.stateSignin.isLoading() ? 1:0
                )
            /// singup button
            Button(action: {
                viewModel.signIn(
                    email: email,
                    password: password
                )
            }, label: {
                Text("Signup")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            })
            .foregroundColor(.black)
            .clipped()
            .opacity(
                viewModel.stateSignin == .LOADING ? 0:1
            )
        }
        .padding(EdgeInsets(top: 12, leading: 64, bottom: 12, trailing: 64))
        .background(Color.primery)
        .cornerRadius(8)
    }
}
