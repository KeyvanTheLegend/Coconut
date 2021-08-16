//
//  LiveChatSummaryView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/13/21.
//

import SwiftUI

struct LiveChatSummaryView : View {
    /// - Dependency Injection
    @ObservedObject var viewModel: LiveChatSummaryViewModel

    var body: some View {
        
        HStack(alignment : .center , spacing : 8){
            
            HStack {
                Image(systemName: "clock")
                    .resizable()
                    .frame(width: 20, height:20, alignment: .top)
                    .foregroundColor(Color.primery)
                Text(viewModel.duration)
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
                Text("\(viewModel.duration)")
                    .font(.body)
                    .foregroundColor(.whiteColor)
            }
            .frame(maxWidth: .infinity , alignment: .center)
            Divider()	
            HStack {
                Image(systemName: "smiley")                        .resizable()
                    .frame(width: 20, height:20, alignment: .top)
                    .foregroundColor(Color.primery)
                Text("\(viewModel.smilesCount)")
                    .font(.body)
                    .foregroundColor(.whiteColor)
            }
            .frame(maxWidth: .infinity , alignment: .trailing)

        }
    }
}
