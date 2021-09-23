//
//  MessageView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/11/21.
//

import SwiftUI
struct ChatTabView: View {
    
    @State var navigateToChatView = false
    @State var navigateToSearchView = false
    
    @StateObject var viewModel = ChatTabViewModel()
    @EnvironmentObject var session : Session
    
    init(){
        UITableView.appearance().backgroundColor = UIColor(named: "BackgroundColor")
        setNavBarAppearence(to: .defualt)
    }
    
    var body: some View {
        
        NavigationView {
            ZStack{
                // MARK: Conversation List
                List{
                    ForEach(viewModel.conversations) { conversation in
                        if !viewModel.blockedEmails.contains(
                            conversation.email.safeString()
                        ) {
                            ZStack{
                                ConversationContentView(
                                    profileImage: conversation.picture,
                                    name: conversation.name,
                                    unreadMessageCount: conversation.unreadMessageCount ?? 0,
                                    isOnline: true
                                )
                                .frame(height: 88, alignment: .center)
                                .frame(maxWidth : .infinity)
                                .background(Color.background)
                                .onTapGesture {
                                    viewModel.setSelectedConversation(conversation: conversation)
                                    navigateToChatView = true
                                }
                            }
                            .listRowBackground(Color.background)
                        }
                    }
                }
                .padding(0)
                
                // MARK: Navigation Links
                Group{
                    NavigationLink(
                        destination:
                            ChatView(withUser: $viewModel.selectedUser)
                            .navigationBarTitleDisplayMode(.inline),
                        isActive: $navigateToChatView
                    ){EmptyView()}
                    .buttonStyle(PlainButtonStyle())
                    .frame(width:0)
                    .opacity(0)
                    
                    NavigationLink(
                        destination:
                            SearchView()
                            .navigationBarTitleDisplayMode(.inline),
                        isActive: $navigateToSearchView
                    ){EmptyView()}
                    .buttonStyle(PlainButtonStyle())
                    .frame(width:0)
                    .opacity(0)
                }
            }
            .padding(0)
            .showTabBar()
            .navigationTitle("Chat")
            // MARK: Navigation Bar Items :
            .navigationBarItems(trailing: Button(action: {
                navigateToSearchView = true
            }, label: {
                HStack{
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20,
                               height: 20,
                               alignment: .center
                        )
                }
                .frame(width: 48, height: 48, alignment: .center)
            }))
        }
        .hasScrollEnabled(true)
        .background(Color.background)
        .ignoresSafeArea(.keyboard)
        .navigationViewStyle(StackNavigationViewStyle())
        
        // MARK: - onAppear :
        .onAppear(perform: {
            viewModel.getAllConversations()
            viewModel.observeBlockedEmails()
            
        })
        .onChange(of: navigateToSearchView) { isNavigated in
            if isNavigated {
                DatabaseManager.shared.removeConversationsObserver(for: session.user?.email ?? "")
            }
            else{
                viewModel.getAllConversations()
            }
        }
        .onChange(of: navigateToChatView) { isNavigated in
            if isNavigated {
                print("HI IM HERE BOROOOOO")
                DatabaseManager.shared.removeConversationsObserver(for: session.user?.email ?? "")
                
                for conversation in viewModel.conversations {
                    DatabaseManager.shared.removeUnreadObserver(forUser: session.user?.email ?? "", conversationID: conversation.conversationId)
                }

            }
            else{
                viewModel.getAllConversations()
            }
        }
        
        
    }
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatTabView()
    }
}




//struct MessageInMessagesListContentView : View {
//
//    var profileImage : String
//    var name : String
//    var message : String
//    var messageNumber : Int
//    @State var startAnimate : Bool = false
//    @State var startTimeAnimate : Bool = false
//    @State var startCloseAnimate : Bool = false
//    @State var requestTimeWidthPercentage : CGFloat = 1
//    @State var contentViewOffset : CGFloat = 400
//    @Binding var isClosed : Bool
//
//    var body: some View {
//
//        GeometryReader { geometry in
//
//            VStack(alignment: .leading, spacing: 8, content: {
//
//                HStack(content: {
//
//                    Image(profileImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 70,
//                               height: 70,
//                               alignment: .center)
//                        .cornerRadius(12)
//                        .padding([.trailing],16)
//                        .padding([.bottom,.top],0)
//                        .clipped()
//
//                    VStack (alignment: .leading, spacing: 6, content: {
//
//                        Text(name)
//                            .foregroundColor(.white)
//                            .font(.title3.weight(.medium))
//                        HStack(alignment: .center){
//                            ZStack{
//
//                                Circle()
//                                    .frame(width: 10, height:10, alignment: .center)
//                                    .foregroundColor(Color.primery)
//
//                            }
//                            Text("Requested to chat")
//                                .foregroundColor(Color.gray)
//                                .font(.footnote.weight(.medium))
//                                .lineLimit(2)
//                        }
//
//                    })
//                    .frame(width: abs(geometry.size.width - (70 + 30 + 32 + 32)),
//                           height: geometry.size.height,
//                           alignment: .leading)
//                    ZStack{
//
//                        Circle()
//                            .frame(width: 25, height:25, alignment: .center)
//                            .foregroundColor(.primery)
//
//                        Image(systemName: "checkmark")
//                            .resizable()
//                            .font(.caption.weight(.semibold))
//                            .foregroundColor(Color.black)
//                            .frame(width: 10, height:10, alignment: .center)
//
//                    }
//                    .frame(width: 30, height:30, alignment: .center)
//                })
//                .frame(width: geometry.size.width - 32, height:70, alignment: .center)
//
//                HStack(alignment : .center){
//
//                }
//                .frame(width: requestTimeWidthPercentage*(geometry.size.width - 32) , height:3, alignment: .center)
//                .background(Color.primery)
//                .cornerRadius(1.5)
//                .onAnimationCompleted(for: requestTimeWidthPercentage, completion: {
//                    print("DONE2")
//                    startCloseAnimate = true
//                    withAnimation(.easeOut(duration: 0.2)) {
//                        contentViewOffset = -400
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                            withAnimation(.easeOut(duration: 20).delay(10)) {
//                                print("START")
//                                isClosed = true
//                            }
//                        }
//                    }
//                })
//                .animation(startTimeAnimate ? Animation.linear(duration: 2):.easeInOut)
//                .onAppear(perform: {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
//
//                        withAnimation(.easeInOut) {
//                            startAnimate = true
//                            contentViewOffset = 0
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
//                            startTimeAnimate  = true
//                            withAnimation(Animation.linear(duration: 2)) {
//                                requestTimeWidthPercentage = 0
//                            }
//                        }
//                    }
//                })
//            })
//            .animation(startCloseAnimate ? .easeInOut :(startTimeAnimate ? nil:.easeInOut))
//            .offset(x: contentViewOffset ,y:0)
//            .onAnimationCompleted(for: contentViewOffset, completion: {
//                print("DONE1")
//                if !startAnimate{
//                    startTimeAnimate  = true
//                    withAnimation(Animation.linear(duration: 2)) {
//                        requestTimeWidthPercentage = 0
//                    }
//                }
//            })
//        }
//    }
//}
//struct MissedMessageRequestInMessagesListContentView : View {
//
//    var profileImage : String
//    var name : String
//    var messageNumber : Int
//
//    var body: some View {
//
//        GeometryReader { geometry in
//
//            HStack(content: {
//
//                Image(profileImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 70,
//                           height: 70,
//                           alignment: .center)
//                    .cornerRadius(12)
//                    .padding([.trailing],16)
//                    .padding([.bottom,.top],0)
//                    .clipped()
//
//                VStack (alignment: .leading, spacing: 8, content: {
//
//                    Text(name)
//                        .foregroundColor(.white)
//                        .font(.title3.weight(.medium))
//                    HStack(alignment: .center){
//                        ZStack{
//
//                            Circle()
//                                .frame(width: 10, height:10, alignment: .center)
//                                .foregroundColor(Color.red)
//
//                        }
//                        Text("Missed chat request")
//                            .foregroundColor(Color.gray)
//                            .font(.footnote.weight(.medium))
//                            .lineLimit(2)
//                    }
//
//                })
//                .frame(width: abs(geometry.size.width - (70 + 30 + 32 + 32)),
//                       height: geometry.size.height,
//                       alignment: .leading)
//
//            })
//        }
//    }
//}
