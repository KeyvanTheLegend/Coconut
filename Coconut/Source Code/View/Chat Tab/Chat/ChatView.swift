//
//  ChatView.swift
//  Coconut
//
//  Created by sh on 8/17/21.
//

import SwiftUI

struct ChatView: View {
    
    @State var text : String = ""
    @State var shouldHaveExteraButtonPadding = false
    @State var testing : CGFloat = 0
    @State var bottomPadding : CGFloat = 0
    @StateObject var viewModel = ChatViewModel()
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
            Spacer()
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .listRowBackground(Color.background)
                .listRowInsets(EdgeInsets())
                .background(Color.background)
                .listStyle(InsetListStyle())
                .background(Color.background)
                .listRowInsets(EdgeInsets())
                .offset(CGSize(width: 0, height: -testing + 10 ))
                .background(Color.background)
                .onChange(of: testing, perform: { value in
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
            SendMessageView(viewModel: viewModel,text: $text)
                .background(Color.background, alignment: .bottom)
                .offset(x: 0 , y: -testing)
                .padding(.bottom , shouldHaveExteraButtonPadding ? bottomPadding : 0)
                .background(Color.background, alignment: .bottom)
                .ignoresSafeArea(.all, edges: .bottom)
                .padding(.top,8)
        }
        .background(Color.background.ignoresSafeArea())
        .ignoresSafeArea(.all, edges: .bottom)
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear(perform: {
            UITextView.appearance().backgroundColor = .clear
            
            if let window = UIApplication.shared.windows.first{
                let tempBottomPadding = window.safeAreaInsets.bottom
                print(tempBottomPadding)
                if tempBottomPadding > 0 {
                    bottomPadding = 34
                    shouldHaveExteraButtonPadding = true
                }
            }
        })
        // MARK: - onAppear
        .onAppear(perform: {
            viewModel.setOtherUser(user : withUser)
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)) { notifictation in
            let keyboardSize = notifictation.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let keyboardheight = keyboardSize.height
            let duration = notifictation.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            shouldHaveExteraButtonPadding = false
            withAnimation(.easeOut(duration: (duration - 0.05)) ) {
                testing  = keyboardheight
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)) { notifictation in
            let duration = notifictation.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            withAnimation(.easeOut(duration: (duration + 0.03)).delay(0.03) ) {
                testing  = 0
                if bottomPadding > 0 {
                    shouldHaveExteraButtonPadding = true
                }
            }
            
        }
        // MARK: - onDisappear
        .onDisappear(perform: {
            viewModel.setConverationID(convesationID: nil)
            viewModel.messages.removeAll()
            
            
        })
        .ignoresSafeArea(.keyboard)
        
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
