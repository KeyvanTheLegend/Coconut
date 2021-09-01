//
//  SendMessageView.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 9/1/21.
//

import SwiftUI

struct SendMessageView : View {
    @ObservedObject var viewModel : ChatViewModel
    @Binding var text :String
    var body: some View {
        VStack(spacing : 8){
            Divider()
            HStack (alignment : .bottom, spacing : 0){
                TextEditor(text: $text)
                    .background(Color.white)
                    .cornerRadius(8, antialiased: true)
                    .frame(minHeight: 40, alignment: .leading)
                    .foregroundColor(.black)
                    .padding(.horizontal,16)
                    .padding(.bottom,8)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .placeholder(
                        when: true,
                        alignment: .leading
                    ){
                        Text("Start typing ...")
                            .zIndex(text.isEmpty ? 2: 0)
                            .padding(.leading , 22)
                            .padding(.bottom , 10)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                Image(systemName: "arrow.up")
                    .frame(width: 40,
                           height: 40,
                           alignment: .center
                    )
                    .background(Color.primery)
                    .cornerRadius(20)
                    .padding([.trailing], 16)
                    .padding([.bottom],8)
                    .foregroundColor(.white)
                    .onTapGesture {
                        viewModel.sendMessage(messageText: text, to: viewModel.user)
                        text = ""
                    }
            }
        }
    }
}
