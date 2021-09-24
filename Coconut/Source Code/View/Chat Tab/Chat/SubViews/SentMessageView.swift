//
//  SentMessageView.swift
//  Coconut
//
//  Created by sh on 9/1/21.
//

import SwiftUI

struct SentMessageView : View {
    var isRead : Bool 
    var messsage : String
    var body: some View {
        ZStack(alignment :.trailing) {
            HStack{
                Spacer()
            Text(messsage)
                .foregroundColor(.black)
                .padding(8)
                .padding([.horizontal],12)
                .padding([.trailing],14)
                .font(.subheadline)
                .background(Color.white)
                .cornerRadius(30, antialiased: false)
            }
            HStack(spacing: 0){
                if isRead{
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 10, height: 10, alignment: .center)
                    .foregroundColor(.primery)
                }
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 10, height: 10, alignment: .center)
                .foregroundColor(.primery)
                .padding(.trailing,10)

            }

        }
        .padding(8)
        .padding(.top , 0)
        .padding(.leading , 64)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .listRowBackground(Color.background)
        .listRowInsets(EdgeInsets())
        .background(Color.background)
    }
}

