//
//  PersonImageNameStatusView.swift
//  Coconut
//
//  Created by sh on 8/13/21.
//

import SwiftUI

struct PersonImageNameLastMessageView: View {
    /// - Dependency Injection
    @ObservedObject var viewModel: PersonImageNameStatusViewModel
    
    var body: some View {
        HStack(alignment : .top ,content: {
            Image(viewModel.profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70,
                       height: 70,
                       alignment: .center)
                .background(Color.primery.opacity(0.1))
                .cornerRadius(12)
                .padding([.trailing],16)
                .padding([.bottom,.top],0)
                .clipped()
            
            VStack (alignment: .leading, spacing: 8, content: {
                
                Text(viewModel.name)
                    .foregroundColor(.white)
                    .font(.title3.weight(.medium))
                Text(viewModel.statusMessage)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .lineLimit(2)
                Spacer()
                
            })
            Spacer()

        })
    }
}
