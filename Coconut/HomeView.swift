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
                    VStack{
                        Text("START CHAT WITH STRANGER")
                            .frame(width: abs(geometry.size.width - 32), height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color.primery)
                            .cornerRadius(12)
                            .padding([.top],16)
                            .font(.title3.italic().weight(.semibold))
                            .foregroundColor(Color.background)
                            .shadow(color: .primery, radius: 5, x: 0, y: 0.0)
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
