//
//  ChatViewHeader.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 9/1/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Introspect

struct ChatHeaderView : View {
    @Binding var user : UserModel?
    @StateObject var viewModel : ChatViewModel
    
    var body: some View {
        HStack(alignment : .top){
            if user?.picture != ""{
                WebImage(url: URL(string: user?.picture ?? ""))
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70,
                           height: 70,
                           alignment: .center)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding([.horizontal],16)
                    .padding([.bottom],16)
                    .padding([.top],8)
                    .clipped()
            }
            else {
                ZStack(alignment: .center){
                    Image("cocoImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35, alignment: .center)
                }
                .frame(width: 70,
                       height: 70,
                       alignment: .center)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding([.horizontal],16)
                .padding([.bottom],16)
                .padding([.top],8)
                
            }
            


//                .hiddenTabBar()
            VStack (alignment: .leading, spacing: 8, content: {

                Text(user?.name ?? "")
                    .foregroundColor(.white)
                    .font(.title3.weight(.medium))
                if viewModel.isTyping{
                HStack{

                    Circle()
                        .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.primery)
                    Text("Typing")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .lineLimit(2)
                }
                }else {
                    HStack{

                        Circle()
                            .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.gray)
                        Text("Last seen recently")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .lineLimit(2)
                    }
                }
                Spacer()

                    
            })
            .padding(.top,16)
            Spacer()
            ZStack(alignment:.center){
                Text("AR")
                    
                    .font(.title3.weight(.semibold))
                    .foregroundColor(Color.primery)
                VStack{
                    
                }
                .frame(width: 40, height: 2, alignment: .center)
                .background(Color.primery)
                .cornerRadius(1)


            }
            .frame(width: 50, height: 50, alignment: .center)
            .padding(.horizontal,16)
            .padding(.vertical , 16)
            
        }.frame(height : 86)
    }
}
