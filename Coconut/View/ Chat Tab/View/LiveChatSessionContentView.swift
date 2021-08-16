//
//  LiveChatSessionContentView.swift
//  Coconut
//
//  Created by sh on 8/13/21.
//

import SwiftUI
import Combine

struct LiveChatSessionContentView : View {
    
    @ObservedObject var viewModel = LiveChatSessionViewModel()
    @State var contentViewOffset :CGFloat = 400
    @State var shouldAnimate = false
    @State private var isAnimationEnable : Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4, content: {
            
            HStack(alignment : .top ,content: {
                
                PersonImageNameStatusView(viewModel: viewModel.personImageNameStatusViewModel)
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
                    isAnimationEnable ? Animation.easeInOut
                        .repeatForever(autoreverses: true):.easeInOut)
            })
            
            LiveChatSummaryView(viewModel: viewModel.summaryViewModel)
        })
        .padding([.trailing],32)
        .offset(x: contentViewOffset ,y:0)

        .onAppear(perform: {
            withAnimation {
                shouldAnimate = true
                contentViewOffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimationEnable = true

            }
        })
    }
    
}
