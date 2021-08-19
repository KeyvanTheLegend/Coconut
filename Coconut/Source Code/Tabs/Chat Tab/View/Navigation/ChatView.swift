//
//  ChatView.swift
//  Coconut
//
//  Created by sh on 8/17/21.
//

import SwiftUI

struct ChatView: View {
    @State var text : String = ""
    var body: some View {
        ZStack(){
            ScrollView {
                GeometryReader { geometry in
                    VStack (alignment: .leading){
                    HStack(alignment : .top){
                        Image("memoji1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 90, alignment: .center)
                            .cornerRadius(12)
                            .clipped()
                            .aspectRatio(contentMode: .fit)
                            .padding([.all],16)
                        VStack (alignment: .leading, spacing: 8, content: {

                            Text("Keyvan")
                                .foregroundColor(.white)
                                .font(.title3.weight(.medium))
                            HStack{
                                
                                Circle()
                                    .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color.primery)
                                Text("Typing")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .lineLimit(2)
                            }
                            Spacer()
                        })
                        .padding(.top,32)
                        Spacer()

                    }.frame(height : 100)
                    Divider()
                        VStack(alignment :.trailing) {
                    Text("Hi Baby Girl How You Doin???")
                        .foregroundColor(.white)
                        .padding(16)
                        .background(Color.primery)
                        .cornerRadius(30)
                        }
                        .padding(16)
                        HStack(alignment :.center) {
                            Spacer()
                    Text("Hi Baby Girl How You Doin???")
                        .foregroundColor(.black)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(30)
                        }
                        .padding(8)
                    Spacer()
                        TextField("HI", text: $text)
                            
                }.frame(width : geometry.size.width, height : 300)
                .background(Color.background)
                }
                .frame(height: 200)
            }
            .background(Color.background
                            .ignoresSafeArea())
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
