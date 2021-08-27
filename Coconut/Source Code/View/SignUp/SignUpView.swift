//
//  SignInView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/23/21.
//

import SwiftUI

/// Signup view using
struct SignUpView: View {
    
    @State var name : String = ""
    @State var email : String = ""
    @State var password : String = ""
    
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack{
            VStack{
                Spacer()
                SignupProfileImageView()
                Group{
                    NameTextField(name: $name)
                    EmailTextField(email: $email)
                    PasswordTextField(password: $password)
                    SingUpButton(
                        name: $name,
                        email: $email,
                        password: $password,
                        viewModel: viewModel
                    )
                    .fullScreenCover(
                        isPresented: $viewModel.isPresentedHomeTabView,
                        content: HomeView.init
                    )
                }
                Group{
                    Spacer()
                    Spacer()
                }
            }
            .background(Color.background.ignoresSafeArea())
            .ignoresSafeArea(.all, edges: .top)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
