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
    @EnvironmentObject var globalObjects: GlobalObjects

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
                                globalObjects.isSignedIn = true
                            }
                        })
                }
                Group{
                    Spacer()
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
        
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
