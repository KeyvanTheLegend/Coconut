//
//  SettingTabView.swift
//  Coconut
//
//  Created by sh on 8/22/21.
//

import SwiftUI

struct SettingTabView: View {
    @State var presentSignin : Bool = false
    @EnvironmentObject var loginState: LoginState

    var body: some View {
        NavigationView{
            ScrollView {
                
                VStack {
                    SettingTabHeaderView()
                    Divider()
                    
//                    HStack(alignment : .center){
//                        VStack (alignment : .center){
//                        Image("memoji1")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .foregroundColor(.primery)
//                            .frame(width: 45, height: 45, alignment: .center)
//                        }
//                        .frame(width: 50, height: 50, alignment: .center)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(12)
//                        .padding(.horizontal , 16)
//                        .padding(.vertical , 4)
//
//                        Text("Avatar")
//                            .font(.title3)
//                            .foregroundColor(.whiteColor)
//                        Spacer()
//                    }
//                    Divider()
//                    HStack(alignment : .center){
//                        VStack (alignment : .center){
//                        Image(systemName: "person.2.fill")
//                            .resizable()
//                            .foregroundColor(.primery)
//                            .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 30, height: 30, alignment: .center)
//                        }
//                        .frame(width: 50, height: 50, alignment: .center)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(12)
//                        .padding(.horizontal , 16)
//                        .padding(.vertical , 4)
//
//                        Text("Friends")
//                            .font(.title3)
//                            .foregroundColor(.whiteColor)
//                        Spacer()
//                    }
//                    Divider()
//                    HStack(alignment : .center){
//                        VStack (alignment : .center){
//                        Image(systemName: "hand.thumbsup.fill")
//                            .resizable()
//                            .foregroundColor(.primery)
//                            .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 22, height: 22, alignment: .center)
//                        }
//                        .frame(width: 50, height: 50, alignment: .center)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(12)
//                        .padding(.horizontal , 16)
//                        .padding(.vertical , 4)
//
//                        Text("Interests")
//                            .font(.title3)
//                            .foregroundColor(.whiteColor)
//                        Spacer()
//                    }
//                    Divider()
                    HStack(alignment : .center){
                        VStack (alignment : .center){
                        Image(systemName: "arrow.left.square")
                            .resizable()
                            .foregroundColor(.primery)
                            .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4)
                        
                        Text("Logout")
                            .font(.title3)
                            .foregroundColor(.whiteColor)
                        Spacer()
                    }
                    .onTapGesture {
                        loginState.isLogin = false
                        let domain = Bundle.main.bundleIdentifier!
                        UserDefaults.standard.removePersistentDomain(forName: domain)
                    }
                    
                    Divider()

                }
                .frame(maxWidth : .infinity)
                .padding(.top,16)
            }
            .fixFlickering()
            .background(Color.background
                            .ignoresSafeArea())
            .navigationBarTitle("Setting")
        }
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}
import SDWebImageSwiftUI

struct SettingTabHeaderView : View {
    @State var selectedImage : UIImage?
    @State var isImageSelected : Bool = false
    @State var showImagePicker : Bool = false
    @State var profilePictureUrl : String = ""

    var body: some View{
        HStack(alignment : .top){
            if selectedImage == nil{
            if UserDefaults.standard.string(forKey: "ProfilePictureUrl") ?? "" != "" {
                WebImage(url: URL(string: UserDefaults.standard.string(forKey: "ProfilePictureUrl") ?? ""))
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .background(Color.primery)
                    .cornerRadius(12)
                    .font(.title)
                    .padding(.horizontal ,16)
                    .onTapGesture {
                        showImagePicker = true
                    }
            }
            }
            else {
                ZStack(alignment: .center){
                    if isImageSelected {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80, alignment: .center)
                        
                    }else{
                    Image("cocoImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35, alignment: .center)
                    }
                    
                }
                .frame(width: 80,
                       height: 80,
                       alignment: .center)
                .background(Color.primery)
                .cornerRadius(12)
                .padding(.horizontal ,16)
                .onTapGesture {
                    showImagePicker = true
                }
                
                
            }
            
            VStack(alignment : .leading){
                Text(UserDefaults.standard.string(forKey: "Name") ?? "")
                    .foregroundColor(.white)
                    .padding(.top , 10)
                    .font(.title3)
                Text(UserDefaults.standard.string(forKey: "Email") ?? "")
                    .foregroundColor(.gray)
                    .padding(.vertical , 4)
                    .font(.body)
                
            }


            Spacer()
        }
        .popover(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, didSet: $isImageSelected)
        }
        .onChange(of: selectedImage, perform: { value in
            if let selectedImage = selectedImage {
                let userEmail = UserDefaults.standard.string(forKey: "Email")!
                let userName = UserDefaults.standard.string(forKey: "Name")!
                let user = UserModel(name: userName, email: userEmail)
                StorageManager.shared.uploadProfilePicture(with: selectedImage.pngData()!, fileName: user.pictureFileName) { result in
                    switch result {
                    
                    case .success(let url):
                        UserDefaults.standard.setValue(url, forKey: "ProfilePictureUrl")
                        print(url)
                        profilePictureUrl = url
                        DatabaseManager.shared.updateProfilePicture(forEmail: user.email, withImageUrl: url)
                        break
                    case .failure(_):
                        break
                    }
                }
            }
        })
//        .onAppear(perform: {
//            profilePictureUrl = UserDefaults.standard.string(forKey: "ProfilePictureUrl") ?? ""
//            print("HIIII \(profilePictureUrl)")
//            print("ASDI \(UserDefaults.standard.string(forKey: "ProfilePictureUrl"))")
//            print("ASDI \(profilePictureUrl)")
//        })
    }
}
