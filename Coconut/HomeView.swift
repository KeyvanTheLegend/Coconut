//
//  ContentView.swift
//  Coconut
//
//  Created by sh on 8/8/21.
//

import SwiftUI

struct HomeView: View {
    
    init() {
        setNavBarAppearence(to: .defualt)
    }
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    VStack(alignment: .center) {
                        StartChatWithStrangerView()
                            .padding([.horizontal],16)
                            .padding([.top],16)
                            .frame(width: abs(geometry.size.width),
                                   height: 100)
                        TitleView(title: "Chat requests")
                            .padding([.leading,.trailing,.top],16)
                        List {
                            HStack(content: {
                                Image("profile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70, alignment: .center)
                                    .cornerRadius(12)
                                    .padding([.trailing],16)
                                    .padding([.bottom,.top],0)
                                    .clipped()
                                
                                VStack (alignment: .leading, spacing: 6, content: {
                                    Text("Keyvan Yaghoubian")
                                        .foregroundColor(.white)
                                        .font(.title3.weight(.medium))
                                    HStack{
                                        Circle()
                                            .frame(width: 10, height:10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(.primery)
                                    Text("Online")
                                        .font(.caption)
                                        .foregroundColor(Color.white)
                                    }
                                })
                                
                                
                            }).listRowBackground(Color.background)
                            HStack(content: {
                                Image("profile2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70, alignment: .center)
                                    .cornerRadius(12)
                                    .padding([.trailing],16)
                                    .padding([.bottom,.top],8)
                                    .clipped()
                                
                                VStack (alignment: .leading, spacing: 6, content: {
                                    Text("Tara Asghari")
                                        .foregroundColor(.white)
                                        .font(.title3.weight(.medium))
                                    HStack{
                                        Circle()
                                            .frame(width: 10, height:10, alignment: .center)
                                            .foregroundColor(.gray)
                                    Text("Offline")
                                        .font(.caption)
                                        .foregroundColor(Color.white)
                                    }
                                })
                                
                                
                            }).listRowBackground(Color.background)
                        }
                        .padding(0)
                        .background(Color.red)
                        .frame(width: geometry.size.width, height: 165, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    .frame(width: geometry.size.width)
                    .navigationTitle("Home")
                }
                .fixFlickering { scrollView in
                    scrollView.background(Color.background)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct StartChatWithStrangerView : View {
    
    var body: some View {
        GeometryReader { geometry in
            Text("START CHAT WITH STRANGER")
                .frame(width: abs(geometry.size.width), height: abs(geometry.size.height), alignment: .center)
                .background(Color.primery)
                .cornerRadius(12)
                .font(.title3.italic().weight(.semibold))
                .foregroundColor(Color.background)
                .shadow(color: .primery, radius: 5, x: 0, y: 0.0)
        }
    }
}
struct TitleView : View {
    var title : String = ""
    var color : Color = Color.white
    var body: some View {
        HStack {
            Text(title)
                .font(.title2.weight(.medium))
                .foregroundColor(color)
            Spacer()
            Button(action: {}, label: {
                Text("See More")
            })
        }
        
    }
}
