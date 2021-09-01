//
//  RecivedMessageView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 9/1/21.
//

import SwiftUI

struct RecivedTextMessage : View {
    var messsage : String

    var body: some View {
        HStack(alignment :.center) {
            Text(messsage)
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
