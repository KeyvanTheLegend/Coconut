//
//  PersonImageNameStatusView.swift
//  Coconut
//
//  Created by sh on 8/13/21.
//

import SwiftUI

struct PersonImageNameStatusView: View {
    var body: some View {
        HStack(alignment : .top ,content: {
            Image("profile2")
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
                
                Text("name")
                    .foregroundColor(.white)
                    .font(.title3.weight(.medium))
                Text("message")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .lineLimit(2)
                Spacer()
                
            })
            Spacer()

        })
    }
}
