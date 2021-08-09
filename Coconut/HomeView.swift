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
                            .padding([.all],16)
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
        }
        
    }
}
