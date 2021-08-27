//
//  SignupButton.swift
//  Coconut
//
//  Created by sh on 8/27/21.
//

import SwiftUI

/// user tap this button to send **signup** request to firebase
struct SingUpButton : View {
    
    @Binding var name : String
    @Binding var email : String
    @Binding var password : String
    /// injected viewModel
    @ObservedObject var viewModel : SignUpViewModel
    
    var body: some View{
        ZStack(alignment: .center){
            /// loading image
            Image(systemName: "circle.dashed")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.white)
                .zIndex(viewModel.state.isLoading() ? 2:0)
                .rotationEffect(viewModel.state.isLoading() ? Angle(degrees: 360):.zero, anchor: .center)
                .animation(viewModel.state.isLoading() ? .easeIn(duration: 1).repeatForever(autoreverses: false):.linear(duration: 0))
                .opacity(viewModel.state.isLoading() ? 1:0)
            /// singup button
            Button(action: {
                viewModel.signUp(name: name, email: email, password: password)
            }, label: {
                Text("Signup")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            })
            .foregroundColor(.black)
            .clipped()
            .opacity((viewModel.state == .LOADING) ? 0:1)
        }
        .padding(EdgeInsets(top: 12, leading: 64, bottom: 12, trailing: 64))
        .background(Color.primery)
        .cornerRadius(8)
    }
}

