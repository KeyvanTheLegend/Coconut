//
//  SignInView.swift
//  Coconut
//
//  Created by sh on 8/23/21.
//

import SwiftUI

struct SignInView: View {
    @State var username : String = ""
    @State var password : String = ""
    @State var isLogin : Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            Text("🥥")
                .font(.system(size: 52))
            Spacer()
            Group{
                UsernameTextField(username: $username)
                PasswordTextField(password: $password)
                LoginButton(isLogin: $isLogin, username: $username)
            }
            Group{
            Spacer()
                SignupViewGroup()
            Spacer()
            }
        }
        .background(Color.background.ignoresSafeArea())
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

struct UsernameTextField: View {
    
    @Binding var username  : String
    
    var body : some View {
        HStack(alignment: .center, spacing: 24, content: {
            Spacer()
            TextField("", text : $username)
                .placeholder(when: username.isEmpty ,alignment: .center, placeholder: {
                    Text("Username")
                        .foregroundColor(Color.white)
                })
                .padding([.leading,.trailing],32)
                .padding([.bottom,.top], 12)
                .foregroundColor(.white)
                .background(Color.whiteColor.opacity(0.2))
                .cornerRadius(8)
                .font(
                    .system(
                        size: 16,
                        weight: .regular,
                        design: .monospaced
                    )
                )
                .multilineTextAlignment(.center)
            Spacer()
        })
    }
}
struct PasswordTextField : View {
    
    @Binding var password :String
    
    var body: some View {
        HStack(alignment: .center, spacing: 24, content: {
            Spacer()
            SecureField("", text : $password)
                
                .placeholder(when: password.isEmpty ,alignment: .center, placeholder: {
                    Text("Password")
                        .foregroundColor(Color.white)
                })
                .foregroundColor(.white)
                .padding([.leading,.trailing],32)
                .padding([.bottom,.top], 12)
                .background(Color.whiteColor.opacity(0.2))

                .cornerRadius(8)
                .font(
                    .system(
                        size: 16,
                        weight: .regular,
                        design: .monospaced
                    )
                )
                .multilineTextAlignment(.center)
                .textContentType(.password)
                .padding(.bottom, 32)
                .padding(.top, 12)
            
            Spacer()
        })
    }
}
struct LoginButton : View {
    
    @Binding var isLogin : Bool
    @Binding var username : String
    
    var body: some View{
        Button(action: {
            self.isLogin = true
            print("HI \(username)")
            
            
        }, label: {
            Text("Login")
                .fontWeight(.medium)
        })
        .padding(EdgeInsets(top: 12, leading: 64, bottom: 12, trailing: 64))
        .background(Color.primery)
        .foregroundColor(.black)
        .cornerRadius(8)
        .clipped()
    }
}
struct SignupViewGroup : View {
    var body: some View {
        HStack(alignment: .center, spacing: 8, content: {
            Text("Don't have an account ?")
                .foregroundColor(.white)
            Button(action: {
                
            }, label: {
                Text("Signup")
                    .foregroundColor(.primery)
                    .padding(3)
            })
            
        })
    }
}
