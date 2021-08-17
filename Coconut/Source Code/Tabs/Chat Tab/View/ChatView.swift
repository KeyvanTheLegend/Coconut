//
//  ChatView.swift
//  Coconut
//
//  Created by sh on 8/17/21.
//

import SwiftUI

struct ChatView: View {

    var body: some View {
            ScrollView {
                GeometryReader { geometry in
                VStack{
//                    HStack(alignment : .center){
//                        Image("profile")
//                            .resizable()
//                            .frame(width: 70, height: 70, alignment: .center)
//                            .aspectRatio(contentMode: .fill)
//                            .cornerRadius(12)
//                            .clipped()
//                            .padding([.all],16)
//                        VStack (alignment: .leading, spacing: 8, content: {
//
//                            Text("KEYVAN")
//                                .foregroundColor(.white)
//                                .font(.title3.weight(.medium))
//                            Text("Typing")
//                                .foregroundColor(.gray)
//                                .font(.caption)
//                                .lineLimit(2)
//                            Spacer()
//
//                        })
//                        .padding(.top,32)
//                        Spacer()
//                    }.frame(height : 200)
//                    .background(Color.red)
//                    Spacer()
                }.frame(width : 1000, height : 800)
                .background(Color.background)
                }
                .frame(height: 800)
            }
            .background(Color.background
                            .ignoresSafeArea())
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
