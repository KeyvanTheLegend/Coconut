//
//  MessageView.swift
//  Coconut
//
//  Created by sh on 8/11/21.
//

import SwiftUI

struct MessageView: View {
    
    init(){
        UITableView.appearance().backgroundColor = UIColor(named: "BackgroundColor")
    }
    @StateObject var viewModel = ChatTabViewModel()
    @State var isClosed :Bool = true
    @State var hasLiveChatSession = false
    @State var listShoudAnimate : Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    
                    VStack(alignment: .leading , spacing: 0){
                        List{
       
                            if hasLiveChatSession{
                                withAnimation(Animation.easeInOut(duration: 10)) {
                                    LiveChatSessionContentView(viewModel: viewModel.liveChatSessionViewModel)
                                        .frame(width: geometry.size.width, height: 120, alignment: .center)
                                        .listRowBackground(Color.background)
                                }

                                
                            }
                            
                            if !isClosed {
                                withAnimation {
                                    MessageInMessagesListContentView(profileImage: "profile3", name: "Faati Ghasemi" , message: "Keyvan Tara karet dare" , messageNumber: 10, isClosed: $isClosed)
                                        .frame(width: geometry.size.width, height: 88, alignment: .center)
                                        .listRowBackground(Color.background)
                                }
                            }
                            //                            MissedMessageRequestInMessagesListContentView(profileImage: "profile5", name: "Mehdi", messageNumber: 2)
                            //                                .frame(width: geometry.size.width, height: 88, alignment: .center)
                            //                                .listRowBackground(Color.background)
                            MessageViewContentView(profileImage: "profile4", name: "Sina Rahimzade", isOnline: true)
                                .listRowBackground(Color.background)
                                .frame(width: geometry.size.width, height: 88, alignment: .center)
                            
                            
                            MessageViewContentView(profileImage: "profile5", name: "Mehdi Falahati", isOnline: false)
                                .listRowBackground(Color.background)
                                .frame(width: geometry.size.width, height: 88, alignment: .center)
                            
                        }
                        .frame(width: geometry.size.width, height: 800 , alignment: .top)
                        .onChange(of: viewModel.hasLiveSesssion) { newValue in
                            withAnimation {
                                print("HI NEW VALUE \(newValue)")
                                hasLiveChatSession = newValue

                            }
                        }
                    }
                    .frame(width: geometry.size.width)
                    .navigationTitle("Chat")
                }
                .fixFlickering { scrollView in
                    scrollView.background(Color.background)
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        withAnimation {
                            isClosed = false
                            listShoudAnimate = true
                        }
                    }
                })
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
struct MessageInMessagesListContentView : View {
    
    var profileImage : String
    var name : String
    var message : String
    var messageNumber : Int
    @State var startAnimate : Bool = false
    @State var startTimeAnimate : Bool = false
    @State var startCloseAnimate : Bool = false
    @State var requestTimeWidthPercentage : CGFloat = 1
    @State var contentViewOffset : CGFloat = 400
    @Binding var isClosed : Bool
    
    var body: some View {
        
        GeometryReader { geometry in

            VStack(alignment: .leading, spacing: 8, content: {
                
                HStack(content: {
                    
                    Image(profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70,
                               height: 70,
                               alignment: .center)
                        .cornerRadius(12)
                        .padding([.trailing],16)
                        .padding([.bottom,.top],0)
                        .clipped()
                    
                    VStack (alignment: .leading, spacing: 6, content: {
                        
                        Text(name)
                            .foregroundColor(.white)
                            .font(.title3.weight(.medium))
                        HStack(alignment: .center){
                            ZStack{
                                
                                Circle()
                                    .frame(width: 10, height:10, alignment: .center)
                                    .foregroundColor(Color.primery)
                                
                            }
                            Text("Requested to chat")
                                .foregroundColor(Color.gray)
                                .font(.footnote.weight(.medium))
                                .lineLimit(2)
                        }
                        
                    })
                    .frame(width: abs(geometry.size.width - (70 + 30 + 32 + 32)),
                           height: geometry.size.height,
                           alignment: .leading)
                    ZStack{
                        
                        Circle()
                            .frame(width: 25, height:25, alignment: .center)
                            .foregroundColor(.primery)
                        
                        Image(systemName: "checkmark")
                            .resizable()
                            .font(.caption.weight(.semibold))
                            .foregroundColor(Color.black)
                            .frame(width: 10, height:10, alignment: .center)
                        
                    }
                    .frame(width: 30, height:30, alignment: .center)
                })
                .frame(width: geometry.size.width - 32, height:70, alignment: .center)
                
                HStack(alignment : .center){
                    
                }
                .frame(width: requestTimeWidthPercentage*(geometry.size.width - 32) , height:3, alignment: .center)
                .background(Color.primery)
                .cornerRadius(1.5)
                .onAnimationCompleted(for: requestTimeWidthPercentage, completion: {
                    print("DONE2")
                    startCloseAnimate = true
                    withAnimation(.easeOut(duration: 0.2)) {
                        contentViewOffset = -400
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.easeOut(duration: 20).delay(10)) {
                                print("START")
                                isClosed = true
                            }
                        }
                    }
                })
                .animation(startTimeAnimate ? Animation.linear(duration: 2):.easeInOut)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
                        
                        withAnimation(.easeInOut) {
                            startAnimate = true
                            contentViewOffset = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
                            startTimeAnimate  = true
                            withAnimation(Animation.linear(duration: 2)) {
                                requestTimeWidthPercentage = 0
                            }
                        }
                    }
                })
            })
            .animation(startCloseAnimate ? .easeInOut :(startTimeAnimate ? nil:.easeInOut))
            .offset(x: contentViewOffset ,y:0)
            .onAnimationCompleted(for: contentViewOffset, completion: {
                print("DONE1")
                if !startAnimate{
                    startTimeAnimate  = true
                    withAnimation(Animation.linear(duration: 2)) {
                        requestTimeWidthPercentage = 0
                    }
                }
            })
        }
    }
}
struct MissedMessageRequestInMessagesListContentView : View {
    
    var profileImage : String
    var name : String
    var messageNumber : Int
    
    var body: some View {
        
        GeometryReader { geometry in
            
            HStack(content: {
                
                Image(profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70,
                           height: 70,
                           alignment: .center)
                    .cornerRadius(12)
                    .padding([.trailing],16)
                    .padding([.bottom,.top],0)
                    .clipped()
                
                VStack (alignment: .leading, spacing: 8, content: {
                    
                    Text(name)
                        .foregroundColor(.white)
                        .font(.title3.weight(.medium))
                    HStack(alignment: .center){
                        ZStack{
                            
                            Circle()
                                .frame(width: 10, height:10, alignment: .center)
                                .foregroundColor(Color.red)
                            
                        }
                        Text("Missed chat request")
                            .foregroundColor(Color.gray)
                            .font(.footnote.weight(.medium))
                            .lineLimit(2)
                    }
                    
                })
                .frame(width: abs(geometry.size.width - (70 + 30 + 32 + 32)),
                       height: geometry.size.height,
                       alignment: .leading)
                
            })
        }
    }
}

struct MessageViewContentView : View {
    
    var profileImage : String
    var name : String
    var isOnline : Bool
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            HStack(content: {
                
                Image(profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70,
                           height: 70,
                           alignment: .center)
                    .cornerRadius(12)
                    .padding([.trailing],16)
                    .padding([.bottom,.top],0)
                    .clipped()
                
                VStack (alignment: .leading, spacing: 6, content: {
                    
                    Text(name)
                        .foregroundColor(.white)
                        .font(.title3.weight(.medium))
                    
                    HStack{
                        
                        Text("Hi, I'm chilling lets talk")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                    }
                })
                .frame(width: geometry.size.width,
                       height: geometry.size.height,
                       alignment: .leading)
            })
        }
    }
}
