//
//  SignInView.swift
//  Coconut
//
//  Created by sh on 8/23/21.
//

import SwiftUI

struct SignUpView: View {
    @State var name : String = ""
    @State var username : String = ""
    @State var password : String = ""
    @State var isSignedUp : Bool = false
    
    var body: some View {
        VStack{
        VStack{
            Spacer()
            ZStack(alignment : .top){
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.primery)
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding(20)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(.primery)
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(8)
                    .background(Color.whiteColor)
                    .cornerRadius(8)
                    .padding(.top , 70)
                    .padding(.leading , 90)
            }
            .padding(.top,32)
            .padding(.bottom,32)

            
            Group{
                NameTextField(name: $name)
                UsernameTextField(username: $username)
                PasswordTextField(password: $password)
                SignUpButton(isSignedUp: $isSignedUp, username: $username)
                    .fullScreenCover(isPresented: $isSignedUp, content: HomeView.init)
                
            }
            Group{
                Spacer()
                Spacer()
            }
        }
        .background(Color.background.ignoresSafeArea())
        .ignoresSafeArea(.all, edges: .top)

    }
        .ignoresSafeArea(.all, edges: .top)

    }
    
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

struct NameTextField: View {
    
    @Binding var name : String
    
    var body : some View {
        HStack(alignment: .center, spacing: 24, content: {
            Spacer()
            TextField("", text : $name)
                .placeholder(when: name.isEmpty ,alignment: .center, placeholder: {
                    Text("Name")
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

struct SignUpButton : View {
    
    @Binding var isSignedUp : Bool
    @Binding var username : String
    
    var body: some View{
        Button(action: {
            self.isSignedUp = true
            print("HI \(username)")
            
            
        }, label: {
            Text("Signup")
                .fontWeight(.medium)
        })
        .padding(EdgeInsets(top: 16, leading: 64, bottom: 16, trailing: 64))
        .background(Color.primery)
        .foregroundColor(.black)
        .cornerRadius(8)
        .clipped()
    }
}
