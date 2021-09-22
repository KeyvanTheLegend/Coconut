//
//  ConversationContentView.swift
//  Coconut
//
//  Created by sh on 9/1/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ConversationContentView : View {
    
    var profileImage : String
    var name : String
    var isOnline : Bool
    
    
    var body: some View {
        
        GeometryReader { geometry in
            HStack(content: {
                if profileImage != ""{
                WebImage(url: URL(string: profileImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFill()
                    .frame(width: 70,
                           height: 70,
                           alignment: .center)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding([.trailing],16)
                    .padding([.bottom,.top],0)
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
                    .padding([.trailing],16)
                    .padding([.bottom,.top],0)
                    
                }

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
