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
    
    @State var name : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var profilePictureUrl : String = ""
    
    @State var isImageSelected: Bool = false
    @State var showImagePicker: Bool = false
    @State var selectedImage: UIImage? = nil

    var body: some View {
        VStack{
            VStack{
                Spacer()
                SignupProfileImageView(
                    viewModel: viewModel,
                    isImageSelected: $isImageSelected,
                    showImagePicker: $showImagePicker,
                    selectedImage: $selectedImage
                )
                Group{
                    NameTextField(name: $name)
                    EmailTextField(email: $email)
                    PasswordTextField(password: $password)
                    SingUpButton(
                        viewModel: viewModel,
                        name: $name,
                        email: $email,
                        password: $password,
                        selectedImage: $selectedImage
                    )
                }
                Group{
                    Spacer()
                    Spacer()
                    EULA()
                        .padding(.bottom,16)
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text(viewModel
                                        .errorSignup?
                                        .title ?? "error"),
                        message: Text(viewModel
                                        .errorSignup?
                                        .description ?? "error"),
                        dismissButton: .default(
                            Text("Dismiss")
                        )
                    )
                }
                .popover(isPresented: $showImagePicker) {
                    ImagePicker(
                        selectedImage: $selectedImage,
                        didSet: $isImageSelected
                    )
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
                Text("License Agreement")
                    .foregroundColor(.primery)
                    .font(.footnote.weight(.semibold))
            })
        }
        .padding(.horizontal , 32)
        .padding(.bottom ,48)

    }
    
}
