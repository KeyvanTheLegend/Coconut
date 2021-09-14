//
//  ChatView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/17/21.
//

import SwiftUI

struct ChatView: View {
    
    @State var messageText : String = ""
    
    @State var safeAreaBottonInset :CGFloat = 0
    
    @State var keyboardDidOpen : Bool = false
    @State var keyboardWillOpen : Bool = false
    
    @State var showActionSheet : Bool = false
    @State var showAlert : Bool = false
    
    @State var userIsTyping : Bool = false
    
    let userTypingSemaphore = DispatchSemaphore(value: 0)
    
    
    @StateObject var viewModel = ChatViewModel()
    @EnvironmentObject var session : Session
    
    @Binding var withUser :UserModel?
    
    var body: some View {
        VStack(alignment :  .leading , spacing: 0){
            
            // MARK: Chat Header:
            ZStack{
                ChatHeaderView(
                    user: $withUser,
                    viewModel: viewModel
                )
                .background(Color.background.opacity(0.95))
                .padding(0)
            }
            .background(
                BlurView()
                    .ignoresSafeArea(
                        .container,
                        edges: .top
                    )
            )
            .zIndex(2)
            Divider()
                .zIndex(2)
            
            // MARK: Messages List :
            ScrollViewReader { scrollViewReader in
                List{
                    ForEach(viewModel.messages) { message in
                        
                        if viewModel.isSentMessage(message: message) {
                            SentMessageView(messsage: message.text)
                                .id(message.id)
                            
                        } else{
                            RecivedTextMessage(messsage: message.text)
                                .id(message.id)
                                .listRowBackground(Color.background)
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .leading
                )
                .hasScrollEnabled(true)
                .listRowBackground(Color.background)
                .background(Color.background)
                
                
                // MARK: .onChange Keyboard
                .onChange(of: keyboardDidOpen, perform: { value in
                    withAnimation {
                        if viewModel.messages.count > 0 {
                            scrollViewReader.scrollTo(
                                viewModel
                                    .messages[viewModel.messages.count - 1]
                                    .id,
                                anchor: .bottom
                            )
                        }
                    }
                })
                
                // MARK: .onChange Messages
                .onChange(of: viewModel.messages.count, perform: { value in
                    withAnimation{
                        if viewModel.messages.count > 0 {
                            scrollViewReader.scrollTo(
                                viewModel
                                    .messages[viewModel.messages.count - 1]
                                    .id,
                                anchor: .bottom
                            )
                        }
                    }
                })
            }
            
            // MARK: Send Message
            SendMessageView(viewModel: viewModel,text: $messageText)
                .background(Color.background, alignment: .bottom)
        }
        .background(Color.background.ignoresSafeArea())
        
        .onTapGesture {
            hideKeyboard()
        }
        .padding(.bottom, keyboardWillOpen ? 0: -safeAreaBottonInset)
        
        // MARK: - .onAppear
        .onAppear(perform: {
            viewModel.setOtherUser(user : withUser)
            UITextView.appearance().backgroundColor = .clear
        })
        
        // MARK: - onDisappear
        .onDisappear(perform: {
            //            viewModel.removeObserver()
        })
        
        // MARK: - .onRecive Keyboard Notifications :
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)) { notifictation in
            keyboardWillOpen = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)) { notifictation in
            keyboardDidOpen = false
            keyboardWillOpen = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidShowNotification)) { notifictation in
            keyboardDidOpen = true
        }
        .introspectTabBarController { (UITabBarController) in
            let tabBarHeight = UITabBarController.tabBar.bounds.height
            if let window = UIApplication.shared.windows.first {
                let phoneSafeAreaBottonInsets = window.safeAreaInsets.bottom
                safeAreaBottonInset = tabBarHeight - phoneSafeAreaBottonInsets
            }
            UITabBarController.tabBar.alpha = 0
        }
        // MARK: Navigation Bar Items :
        .navigationBarItems(trailing: Button(action: {
            showActionSheet = true
        }, label: {
            HStack{
                Spacer()
                Image(systemName: "ellipsis")
                    .frame(width: 20,
                           height: 20,
                           alignment: .center
                    )
            }
            .frame(width: 48, height: 48, alignment: .center)
        }))
        // MARK: Action Sheet :
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text(withUser?.email ?? ""),
                buttons: [
                    .destructive(Text("Block")){
                        DatabaseManager.shared.blockUser(with: withUser!.email.safeString(), for: UserDefaults.standard.string(forKey: "Email")!.safeString()) { isSuccess in
                            if isSuccess {
                                
                            }
                        }
                    },
                    .destructive(Text("Report")){
                        DatabaseManager.shared.reportUser(with: withUser!.email.safeString()) { isSuccess in
                            print("HI IM HERE")
                            self.showAlert = true
                        }
                    },
                    .cancel(Text("Cancle"))
                ]
            )
        }
        // MARK: Alerts :
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Reported"),
                message: Text("This user is reported for breaking licance agreement"),
                dismissButton: .default(
                    Text("Dismiss")
                )
            )
        }
        .onChange(of: messageText, perform: { _ in
            if userIsTyping{
                userTypingSemaphore.signal()
            }
            if !userIsTyping {
                guard let conversationID = viewModel.conversationID else{return}
                DatabaseManager.shared.userIsTyping(with: UserDefaults.standard.string(forKey: "Email")!.safeString(), in: conversationID, isTyping: true)
                userIsTyping = true
            }
            
            DispatchQueue.global().async {
                let result =  userTypingSemaphore.wait(timeout: DispatchTime.now() + 0.5)
                if result == .timedOut && userIsTyping {
                    userIsTyping = false
                    DatabaseManager.shared.userIsTyping(with: UserDefaults.standard.string(forKey: "Email")!.safeString(), in: viewModel.conversationID ?? "", isTyping: false)
                }
            }
        })
    }
}

//struct ChatHeaderView : View {
//    @Binding var user : UserModel?
//
//    var body: some View {
//        VStack(alignment : .center, spacing : 4){
//            WebImage(url: URL(string: user?.picture ?? ""))
//                .resizable()
//                .placeholder(Image("profile"))
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 90, height: 90, alignment: .center)
//                .cornerRadius(45)
//                .clipped()
//                .aspectRatio(contentMode: .fit)
//                .hiddenTabBar()
//            VStack (alignment: .leading, spacing: 0, content: {
//                Text(user?.name ?? "")
//                    .foregroundColor(.white)
//                    .font(.title3.weight(.medium))
//            })
//
//
//        }.frame(height : 120)
//        .frame(maxWidth : .infinity)
//        .background(Color.background)
//        .zIndex(2)
//    }
//}
