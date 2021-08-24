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
    @State var showSignUpView : Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                ZStack{
                Text("🥥")
                    .font(.system(size: 46))
                }
                .frame(width: 90, height: 90, alignment: .center)
                .background(Color.whiteColor.opacity(0.2))
                .cornerRadius(12)

                Spacer()
                Group{
                    UsernameTextField(username: $username)
                    PasswordTextField(password: $password)
                    LoginButton(isLogin: $isLogin, username: $username)
                        .fullScreenCover(isPresented: $isLogin, content: HomeView.init)
                    
                }
                Group{
                    Spacer()
                    SignupViewGroup(showSignUpView: $showSignUpView)
                    NavigationLink(
                        destination: SignUpView(),
                        isActive: $showSignUpView,
                        label: {
                            EmptyView()
                        })
                    Spacer()
                }
            }
            .background(Color.background.ignoresSafeArea())
            .ignoresSafeArea(.container)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .previewDevice("iPhone 8")
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
                .padding([.bottom,.top], 16)
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
        .padding(.bottom , 16)
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
                .padding([.bottom,.top], 16)
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
        .padding(EdgeInsets(top: 16, leading: 64, bottom: 16, trailing: 64))
        .background(Color.primery)
        .foregroundColor(.black)
        .cornerRadius(8)
        .clipped()
    }
}
struct SignupViewGroup : View {
    @Binding var showSignUpView : Bool
    var body: some View {
        HStack(alignment: .center, spacing: 8, content: {
            Text("Don't have an account ?")
                .foregroundColor(.white)
            Button(action: {
                showSignUpView = true
            }, label: {
                Text("Signup")
                    .foregroundColor(.primery)
                    .padding(3)
            })
            
        })
    }
}
