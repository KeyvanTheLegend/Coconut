//
//  ChatView.swift
//  Coconut
//
//  Created by sh on 8/17/21.
//

import SwiftUI

struct ChatView: View {
    init() {
        UINavigationBar.appearance().prefersLargeTitles = false
    }
    var body: some View {
            ScrollView {
                VStack{
                    HStack(alignment : .center){
                        Image("profile")
                            .resizable()
                            .frame(width: 70, height: 70, alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(12)
                            .clipped()
                            .padding([.all],16)
                        VStack (alignment: .leading, spacing: 8, content: {
                            
                            Text("KEYVAN")
                                .foregroundColor(.white)
                                .font(.title3.weight(.medium))
                            Text("Typing")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .lineLimit(2)
                            Spacer()
                            
                        })
                        .padding(.top,32)
                        Spacer()
                    }
                }.frame(maxWidth : .infinity , maxHeight: .infinity)
                Divider()

            }
            .fixFlickering(configurator: { scrollView in
                scrollView.background(Color.background)
            })
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
