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
    
    @State var isClosed :Bool = true
    @State var listShoudAnimate : Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    
                    VStack(alignment: .leading , spacing: 0){
                        List{
                            LiveChatSessionContentView(profileImage: "profile2", name: "Tara Asghari", message: "Hi Keyvan, I want to talk with you 👅", messageNumber: 12)
                                .frame(width: geometry.size.width, height: 120, alignment: .center)
                                .listRowBackground(Color.background)
                        }
                        .frame(width: geometry.size.width, height: 132, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        //                        Text("")
                        //                            .padding([.leading,.top],0)
                        //                            .foregroundColor(Color.white)
                        //                            .font(.title3.bold())
                        List{
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
                        .frame(width: geometry.size.width, height: 400 , alignment: .top)
                    }
                    .frame(width: geometry.size.width)
                    .navigationTitle("Chat")
                }
                .fixFlickering { scrollView in
                    scrollView.background(Color.background)
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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

struct LiveChatSessionContentView : View {
    @State private var scaleValue : CGFloat = 1
    
    var profileImage : String
    var name : String
    var message : String
    var messageNumber : Int
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 16, content: {
                HStack(alignment : .top ,content: {
                    
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
                        Text(message)
                            .foregroundColor(.gray)
                            .font(.caption)
                            .lineLimit(2)
                        Spacer()
                        
                    })
                    .frame(width: abs(geometry.size.width - (70 + 60 + 64)),
                           height: geometry.size.height,
                           alignment: .leading)
                    ZStack{
                        
                        Rectangle()
                            .foregroundColor(.primery)
                            .frame(width: 50, height:30, alignment: .center)
                            .cornerRadius(8)
                        
                        Text("LIVE")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(Color.black)
                    }
                    .frame(width: 60, height:80, alignment: .center)
                    .shadow(color: .primery, radius: 2, x: 0, y: 0.0)
                    .scaleEffect(scaleValue)
                    .animation(
                        Animation.easeIn.delay(0)
                            .repeatForever(autoreverses: true)
                    )
                    .onAppear(perform: {
                        scaleValue = 0.9
                    })
                })
                .frame(width: geometry.size.width - 32, height:70, alignment: .top)
                
                HStack(alignment : .center , spacing : 8){
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 20, height:20, alignment: .top)
                            .foregroundColor(Color.primery)
                        Text("00:14")
                            .font(.body)
                            .foregroundColor(.whiteColor)
                    }
                    
                    .frame(maxWidth: .infinity , alignment: .leading)
                    Divider()
                    HStack {
                        Image(systemName: "message")
                            .resizable()
                            .frame(width: 20, height:20, alignment: .top)
                            .foregroundColor(Color.primery)
                        Text("15992")
                            .font(.body)
                            .foregroundColor(.whiteColor)
                    }
                    .frame(maxWidth: .infinity , alignment: .center)
                    Divider()
                    HStack {
                        Image(systemName: "smiley")                        .resizable()
                            .frame(width: 20, height:20, alignment: .top)
                            .foregroundColor(Color.primery)
                        Text("85 times")
                            .font(.body)
                            .foregroundColor(.whiteColor)
                    }
                    .frame(maxWidth: .infinity , alignment: .trailing)
                    //
                    //                    Image(systemName: "smiley")
                    //                        .resizable()
                    //                        .frame(width: 20, height:20, alignment: .top)
                    //                        .foregroundColor(Color.primery)
                    //                    Text("75 times")
                    //                        .font(.caption)
                    //                        .foregroundColor(.gray)
                    //                        .frame(maxWidth: .infinity , alignment: .leading)
                    //
                    //                    Image(systemName: "message")
                    //                        .frame(width: 20, height:20, alignment: .top)
                    //                        .foregroundColor(Color.primery)
                    //                    Text("1000 msg")
                    //                        .font(.caption)
                    //                        .foregroundColor(.gray)
                    //                        .frame(maxWidth: .infinity , alignment: .leading)
                    
                }
                .frame(width: geometry.size.width - 32, height: 28, alignment: .leading)
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
