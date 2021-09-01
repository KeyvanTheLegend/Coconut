//
//  SearchResultView.swift
//  Coconut
//
//  Created by sh on 9/1/21.
//

import SwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct SearchResultContentView : View {
    
    var profileImage : String
    var name : String
    var isOnline : Bool
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            HStack(content: {
                
                WebImage(url: URL(string: profileImage))
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70,
                           height: 70,
                           alignment: .center)
                    .background(Color.gray.opacity(0.2))
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
