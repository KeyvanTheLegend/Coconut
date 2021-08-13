//
//  LiveChatSessionContentView.swift
//  Coconut
//
//  Created by sh on 8/13/21.
//

import SwiftUI

struct LiveChatSessionContentView : View {
    
    @State private var isAnimationEnable : Bool = false
    
    var profileImage : String
    var name : String
    var message : String
    var messageNumber : Int
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4, content: {
            
            HStack(alignment : .top ,content: {
                
                PersonImageNameStatusView()
                    .frame(maxWidth : .infinity)
                
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
                .padding([.leading],16)
                .shadow(color: .primery, radius: 2, x: 0, y: 0.0)
                .scaleEffect(isAnimationEnable ? 1.1:1)
                .animation(
                    Animation.easeInOut
                        .repeatForever(autoreverses: true))
            })
            
            LiveChatSummaryView()
            
        })
        .padding([.trailing],32)
        .onAppear(perform: {
            isAnimationEnable = true
        })
    }
    
}
