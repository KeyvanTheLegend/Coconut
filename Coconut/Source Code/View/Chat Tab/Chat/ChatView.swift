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
    @Binding var withUser :UserModel?
    
    var body: some View {
        VStack(alignment :  .leading , spacing: 0){
            ZStack{
                ChatHeaderView(user: $withUser , viewModel:  viewModel)
                    .background(Color.background.opacity(0.95))
                    .padding(0)
            }
            .background(
                BlurView().ignoresSafeArea(.container, edges: .top)
            )
            .zIndex(2)
            Divider()
                .zIndex(2)
            ScrollViewReader { scrollViewReader in
                List{
                    if let userEmail = viewModel.userEmail {
                        ForEach(viewModel.messages) { item in
                            if userEmail == item.senderEmail {
                                SentMessageView(messsage: item.text)
                                    .id(item.id)
                                
                            }else{
                                RecivedTextMessage(messsage: item.text)
                                    .id(item.id)
                                    .listRowBackground(Color.background)
                            }
                        }
                    }
                }
                .hasScrollEnabled(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .listRowBackground(Color.background)
                .background(Color.background)
                .onChange(of: keyboardDidOpen, perform: { value in
                    withAnimation {
                        if viewModel.messages.count > 0 {
                            scrollViewReader.scrollTo(viewModel.messages[viewModel.messages.count - 1].id,anchor: .bottom)
                        }
                    }
                })
                .onChange(of: viewModel.messages.count, perform: { value in
                    withAnimation{
                        if viewModel.messages.count > 0 {
                            print("onchange viewmodel message \(viewModel.messages.count)")
                            print("ID \(viewModel.messages[viewModel.messages.count - 1 ].id)")
                            scrollViewReader.scrollTo(viewModel.messages[viewModel.messages.count - 1 ].id, anchor: .bottom)
                        }
                    }
                })
                
            }

            SendMessageView(viewModel: viewModel,text: $messageText)
                .background(Color.background, alignment: .bottom)
        }
        .background(Color.background.ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear(perform: {
            UITextView.appearance().backgroundColor = .clear

        })
        // MARK: - onAppear
        .onAppear(perform: {
            viewModel.setOtherUser(user : withUser)
        })
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
            
//                print("TABBAR : ENTERED ")
                let tabBarHeight = UITabBarController.tabBar.bounds.height
//                print("TABBAR : tabBarHeight : \(tabBarHeight)")
                if let window = UIApplication.shared.windows.first{
                    let phoneSafeAreaBottonInsets = window.safeAreaInsets.bottom
                    safeAreaBottonInset = tabBarHeight - phoneSafeAreaBottonInsets

//                    print("TABBAR : safeAreaBottonInset : \(safeAreaBottonInset)")
            }
            UITabBarController.tabBar.alpha = 0
        }
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
        
        // MARK: - onDisappear
        .onDisappear(perform: {
//            viewModel.removeObserver()
        })
        .padding(.bottom, keyboardWillOpen ? 0: -safeAreaBottonInset)
        .colorScheme(.dark)
        

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
