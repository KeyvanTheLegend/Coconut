//
//  LiveChatSummaryView.swift
//  Coconut
//
//  Created by sh on 8/13/21.
//

import SwiftUI

struct LiveChatSummaryView : View {
    
    var body: some View {
        
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
        }
    }
}
