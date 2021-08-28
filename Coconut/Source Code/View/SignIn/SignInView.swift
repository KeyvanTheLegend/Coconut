//
//  SignInView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/23/21.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var viewModel = SigninViewModel()
    
    var body: some View {
        NavigationView {
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
                    EmailTextField(email: $viewModel.email)
                    PasswordTextField(password: $viewModel.password)
                    SigninButton(viewModel: viewModel)
                    .fullScreenCover(
                        isPresented: $viewModel.presentHomeTabView,
                        content: HomeView.init
                    )
                }
                Group
                {
                    Spacer()
                    SignupViewGroup(showSignUpView: $viewModel.showSignUpView)
                    NavigationLink(
                        destination: SignupView(),
                        isActive: $viewModel.showSignUpView,
                        label: {
                            EmptyView()
                        })
                    Spacer()
                }
                /// Alert
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text(viewModel.errorSignin?.title ?? "error"),
                        message: Text(viewModel.errorSignin?.description ?? "error"),
                        dismissButton: .default(Text("Dismiss")
                                                    .foregroundColor(Color.red)
                        )
                    )
                }
            }
            .background(Color.background.ignoresSafeArea())
            .ignoresSafeArea(.container)
            .onTapGesture {
                hideKeyboard()
            }
        }
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
