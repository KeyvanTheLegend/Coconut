//
//  ContentView.swift
//  Coconut
//
//  Created by sh on 8/8/21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    VStack{
                        Text("Hello, world!")
                            .padding()
                    }
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
