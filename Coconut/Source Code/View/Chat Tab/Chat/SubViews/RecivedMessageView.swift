//
//  RecivedMessageView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 9/1/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecivedTextMessage : View {
    var messsage : MessageModel

    var body: some View {
        if messsage.isPhoto ?? false{
            WebImage(url: URL(string: messsage.text))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaledToFill()
                .frame(width: 250,
                       height: 250,
                       alignment: .center)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding([.trailing],16)
                .padding([.bottom,.top],0)
                .clipped()
                .padding(16)
                .padding(.bottom , 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .listRowBackground(Color.background)
                .listRowInsets(EdgeInsets(.zero))
                .background(Color.background)
                .listStyle(InsetListStyle())

        }else {
            HStack(alignment :.center) {
                Text(messsage.text)
                    .foregroundColor(.white)
                    .padding(8)
                    .padding([.horizontal],12)
                    .background(Color.primery)
                    .cornerRadius(30)
                    .font(.subheadline)
            }
            .padding(16)
            .padding(.bottom , 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .listRowBackground(Color.background)
            .listRowInsets(EdgeInsets(.zero))
            .background(Color.background)
            .listStyle(InsetListStyle())
        }
    }
}
