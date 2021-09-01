//
//  SentMessageView.swift
//  Coconut
//
//  Created by sh on 9/1/21.
//

import SwiftUI

struct SentMessageView : View {
    var messsage : String
    var body: some View {
        HStack(alignment :.center) {
            Spacer()
            Text(messsage)
                .foregroundColor(.black)
                .padding(8)
                .padding([.horizontal],12)
                .font(.subheadline)
                .background(Color.white)
                .cornerRadius(30, antialiased: false)
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
