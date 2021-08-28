//
//  SignupButton.swift
//  Coconut
//
//  Created by sh on 8/27/21.
//

import SwiftUI

/// user tap this button to send **signup** request to firebase
struct SingUpButton : View {
    
    /// injected viewModel
    @ObservedObject var viewModel : SignupViewModel
    
    var body: some View{
        ZStack(alignment: .center){
            /// loading image
            Image(systemName: "circle.dashed")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.white)
                .zIndex(
                    viewModel.stateSignup.isLoading() ? 2:0
                )
                .rotationEffect(
                    viewModel.stateSignup.isLoading() ? Angle(degrees: 360) : .zero,
                    anchor: .center
                )
                .animation(
                    viewModel.stateSignup.isLoading() ?
                        .easeIn(duration: 1).repeatForever() : .linear(duration: 0)
                )
                .opacity(
                    viewModel.stateSignup.isLoading() ? 1:0
                )
            /// singup button
            Button(action: {
                viewModel.signUp()
            }, label: {
                Text("Signup")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            })
            .foregroundColor(.black)
            .clipped()
            .opacity(
                viewModel.stateSignup == .LOADING ? 0:1
            )
        }
        .padding(EdgeInsets(top: 12, leading: 64, bottom: 12, trailing: 64))
        .background(Color.primery)
        .cornerRadius(8)
    }
}

