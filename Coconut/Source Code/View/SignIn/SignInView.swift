//
//  SignInView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/23/21.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var viewModel = SigninViewModel()
    
    @EnvironmentObject var session: Session
    
    @State var showSignUpView : Bool = false
    
    @State var email : String = ""
    @State var password : String = ""
    
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                ZStack {
                    Text("🥥")
                        .font(.system(size: 46))
                }
                .frame(
                    width: 90,
                    height: 90,
                    alignment: .center
                )
                .background(Color.whiteColor.opacity(0.2))
                .cornerRadius(12)
                Spacer()
                Group
                {
                    EmailTextField(email: $email)
                    PasswordTextField(password: $password)
                    SigninButton(
                        viewModel: viewModel,
                        email: $email,
                        password: $password
                    )
                }
                Group
                {
                    Spacer()
                    SignupViewGroup(showSignUpView: $showSignUpView)
                    NavigationLink(
                        destination: SignupView(),
                        isActive: $showSignUpView,
                        label: {EmptyView()})
                    Spacer()
                }
            }
            .background(Color.background.ignoresSafeArea())
            .ignoresSafeArea(.container)
            .onTapGesture {
                hideKeyboard()
            }
            // MARK: .onAppear :
            .onAppear(perform: {
                setNavBarAppearence(to: .clear)
            })
            // MARK: .screenCover
            .fullScreenCover(isPresented: $session.isSignedIn, content: {
                HomeView()
            })
            // MARK: Alert :
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title:
                        Text(viewModel
                                .errorSignin?
                                .title ?? "error"),
                    message:
                        Text(viewModel
                                .errorSignin?
                                .description ?? "error"),
                    dismissButton:
                        .default(Text("Dismiss"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .previewDevice("iPhone 8")
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
