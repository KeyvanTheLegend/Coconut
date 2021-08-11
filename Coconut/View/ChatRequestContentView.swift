//
//  MustMeetsContentView.swift
//  Coconut
//
//  Created by sh on 8/10/21.
//

import SwiftUI

struct ChatRequestContentView : View {
    
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
                        
                        Circle()
                            .frame(width: 10, height:10, alignment: .center)
                            .foregroundColor(isOnline ? .primery : .gray)
                        
                        Text(isOnline ? "Online" : "Offline")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                })
                .frame(width: geometry.size.width,
                       height: geometry.size.height,
                       alignment: .leading)
            })
        }
    }
}
