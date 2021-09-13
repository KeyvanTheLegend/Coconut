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
            WebImage(url: URL(string: user?.picture ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80, alignment: .center)
                .cornerRadius(12)
                .clipped()
                .aspectRatio(contentMode: .fit)
                .padding([.all],16)
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
            .padding(.top,32)
            Spacer()

        }.frame(height : 100)
    }
}
