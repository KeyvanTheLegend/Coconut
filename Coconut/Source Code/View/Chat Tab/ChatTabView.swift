//
//  MessageView.swift
//  Coconut
//
//  Created by sh on 8/11/21.
//

import SwiftUI
struct ChatTabView: View {
    
    @StateObject var viewModel = ChatTabViewModel()
    
    @State var isClosed :Bool = true
    @State var hasLiveChatSession = false
    @State var listShoudAnimate : Bool = false
    
    @State var navigateToChatView = false
    @State var navigateToSearchView = false
    
    @State var selectedUser : UserModel?
    @State var selectedConversationId : String?
    
    init(){
        UITableView.appearance().backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    var body: some View {
        
        NavigationView {
            ZStack{
                List{
                    ForEach(viewModel.conversations) {item in
                        ZStack{
                            SearchResultContentView(
                                profileImage: item.picture,
                                name: item.name,
                                isOnline: true
                            )
                            .frame(height: 88, alignment: .center)
                            .frame(maxWidth : .infinity)
                            .background(Color.background)
                            .onTapGesture {
                                print("SELECTED IS \(item)")
                                print("SELECTED CONV IS \(item.userToken)")
                                let user = UserModel(
                                    name: item.name,
                                    email: item.email,
                                    picture: item.picture,
                                    userToken: item.userToken,
                                    sharedConversastion: item.conversationId
                                )
                                selectedUser = user
                                navigateToChatView = true
                                
                            }
                        }
                        .listRowBackground(Color.background)

                    }
                }
                .padding(0)
                NavigationLink(
                    destination:
                        ChatView(withUser: $selectedUser)
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
            .padding(0)

            //                            if hasLiveChatSession{
            //                                withAnimation(Animation.easeInOut(duration: 10)) {
            //                                    LiveChatSessionView(viewModel: viewModel.liveChatSessionViewModel)
            //                                        .frame(height: 120, alignment: .center)
            //                                        .listRowBackground(Color.background)
            //                                        .listRowInsets(.init(top: 8,
            //                                                             leading: 16,
            //                                                             bottom: 8,
            //                                                             trailing: -16))
            //                                }
            //
            //
            //                            }
            //                            if !isClosed {
            //                                withAnimation {
            //                                    MessageInMessagesListContentView(profileImage: "profile3", name: "Faati Ghasemi" , message: "Keyvan Tara karet dare" , messageNumber: 10, isClosed: $isClosed)
            //                                        .frame(height: 88, alignment: .center)
            //                                        .listRowBackground(Color.background)
            //                                        .listRowInsets(.init(top: 4,
            //                                                             leading: 16,
            //                                                             bottom: 4,
            //                                                             trailing: -16))
            //
            //                                }
            //                            }
            //                            MissedMessageRequestInMessagesListContentView(profileImage: "profile5", name: "Mehdi", messageNumber: 2)
            //                                .frame(width: geometry.size.width, height: 88, alignment: .center)
            //                                .listRowBackground(Color.background)
            
            
            //                            MessageViewContentView(profileImage: "profile5", name: "Mehdi Falahati", isOnline: false)
            //                                .listRowBackground(Color.background)
            //                                .listRowInsets(.init(top: 0,
            //                                                     leading: 16,
            //                                                     bottom: 0,
            //                                                     trailing: 0))
            //                                .frame(height: 88, alignment: .center)
            //
            //                        }
            //                        .frame(alignment: .top)
            //                        .onChange(of: viewModel.hasLiveSesssion) { newValue in
            //                            withAnimation {
            //                                print("HI NEW VALUE \(newValue)")
            //                                hasLiveChatSession = newValue
            //
            //                            }
            //                        }
            
            //                        Group{
            //                            /// - NavigationLinks
            
            //                        }
            
            //                    }
            //                    .onAppear(perform: {
            //                        UINavigationBar.appearance().prefersLargeTitles = true
            //                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //                            withAnimation {
            //                                isClosed = false
            //                                listShoudAnimate = true
            //                            }
            //                        }
            //                    })
            .showTabBar()
            .navigationTitle("Chat")
            
            //
            //
            //            }
            //            .background(Color.background
            //                            .ignoresSafeArea())
            
        }
        .hasScrollEnabled(true)
        .background(Color.background)
        .ignoresSafeArea(.keyboard)
        // MARK: - onAppear :
        .onAppear(perform: {
            viewModel.getAllConversations()
            DatabaseManager.shared.log(logText: "\(Date())  | action : chatTab appeared")
        })
        .navigationViewStyle(StackNavigationViewStyle())

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
