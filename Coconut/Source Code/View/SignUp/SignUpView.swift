//
//  SignInView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/23/21.
//

import SwiftUI

/// Signup view using
struct SignupView: View {
    
    @StateObject var viewModel = SignupViewModel()
    @EnvironmentObject var session: Session

    var body: some View {
        VStack{
            VStack{
                Spacer()
                SignupProfileImageView(viewModel: viewModel)
                Group{
                    NameTextField(name: $viewModel.name)
                    EmailTextField(email: $viewModel.email)
                    PasswordTextField(password: $viewModel.password)
                    SingUpButton(viewModel: viewModel)
                        .onChange(of: viewModel.isPresentedHomeTabView, perform: { value in
                            if value {
                                session.isSignedIn = true
                            }
                        })
                }
                Group{
                    Spacer()
                    EULA()
                    Spacer()
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text(viewModel.errorSignup?.title ?? "error"),
                        message: Text(viewModel.errorSignup?.description ?? "error"),
                        dismissButton: .default(
                            Text("Dismiss")
                        )
                    )
                }
                .popover(isPresented: $viewModel.showImagePicker) {
                    ImagePicker(selectedImage: $viewModel.selectedImage, didSet: $viewModel.isImageSelected)
                }
            }
            .background(Color.background.ignoresSafeArea())
            .ignoresSafeArea(.all, edges: .top)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.background)
        
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
struct EULA : View {
    
    var body: some View {
        VStack(alignment : .center,spacing : 0){
            Text("By Signing up you are acception the ")
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.vertical , 8)
            Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!, label: {
                Text("License Agreement")                    .foregroundColor(.primery)
                    .font(.footnote.weight(.semibold))
            })
        }
        .padding(.horizontal , 32)
        .padding(.bottom ,48)

    }
    
}
