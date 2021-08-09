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
                    }
                    .frame(width: geometry.size.width )
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
