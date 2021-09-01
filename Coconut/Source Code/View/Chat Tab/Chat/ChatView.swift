//
//  ChatView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/17/21.
//

import SwiftUI

struct ChatView: View {
    
    @State var messageText : String = ""
    @State var safeAreaInsetsBotton :CGFloat = 0
    @State var keyboardDidOpen : Bool = false
    @State var keyboardWillOpen : Bool = false
    @State var keyboardheight : CGFloat = 0

    @ObservedObject var viewModel = ChatViewModel()
    @Binding var withUser :UserModel?
    
    var body: some View {
        VStack(alignment :  .leading , spacing: 0){
            ZStack{
                ChatHeaderView(user: $withUser)
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
                .listRowInsets(EdgeInsets())
                .background(Color.background)
                .listStyle(InsetListStyle())
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
            if let window = UIApplication.shared.windows.first{
                safeAreaInsetsBotton = window.safeAreaInsets.bottom
            }
        })
        // MARK: - onAppear
        .onAppear(perform: {
            print("on APPEAR \(withUser)")
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
        // MARK: - onDisappear
        .onDisappear(perform: {
            viewModel.setConverationID(convesationID: nil)
            viewModel.messages.removeAll()
            viewModel.setOtherUser(user: nil)
        })
        .padding(.bottom, keyboardWillOpen ? 0: -safeAreaInsetsBotton)
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //            ChatView(converastionId: nil)
        }
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
