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
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().barTintColor = UIColor(named: "BackgroundColor")
        UITabBar.appearance().backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    @State private var selection = 1
    
    var body: some View {
        TabView(selection : $selection) {
            
            Text("HI")
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("messages")
                }
                .tag(0)
            
            GeometryReader { geometry in
                NavigationView {
                    ScrollView {
                        VStack(alignment: .center) {
                            StartChatWithStrangerView()
                                .padding([.horizontal],16)
                                .padding([.top],16)
                                .frame(width: abs(geometry.size.width),
                                       height: 90)
                            TitleView(title: "Chat requests")
                                .padding([.leading,.trailing,.top],16)
                            List {
                                
                                ChatRequestContentView(profileImage: "profile",
                                                       name: "Keyvan Yaghoubian",
                                                       isOnline: true)
                                    .frame(width: geometry.size.width,
                                           height: 70,
                                           alignment: .leading)
                                    .listRowBackground(Color.background)

                                ChatRequestContentView(profileImage: "profile2",
                                                       name: "Tara Asghari",
                                                       isOnline: true)
                                    .frame(width: geometry.size.width,
                                           height: 70 + 16 ,
                                           alignment: .leading)
                                    .listRowBackground(Color.background)
                                
                            }
                            .padding(0)
                            .background(Color.red)
                            .frame(width: geometry.size.width, height: 180, alignment: .top)
                            .hasScrollEnabled(false)
                            
                            TitleView(title: "Must Meets")
                                .padding([.leading,
                                          .trailing,
                                          .top],16)
                            
                            List {
                                
                                MustMeetsContentView(profileImage: "profile3",
                                                     name: "Fati Ghasemi",
                                                     matchPercentage: CGFloat(0.85))
                                    .listRowBackground(Color.background)
                                    .frame(width: geometry.size.width,
                                           height: 70 + 16,
                                           alignment: .leading)
                                
                                MustMeetsContentView(profileImage: "profile4",
                                                     name: "Sina Rahim",
                                                     matchPercentage: CGFloat(0.7))
                                    .listRowBackground(Color.background)
                                    .frame(width: geometry.size.width,
                                           height: 70 + 16,
                                           alignment: .leading)
                                
                                MustMeetsContentView(profileImage: "profile5",
                                                     name: "Mehdi Falahati",
                                                     matchPercentage: CGFloat(1))
                                    .listRowBackground(Color.background)
                                    .frame(width: geometry.size.width,
                                           height: 70 + 16,
                                           alignment: .leading)
                                
                            }
                            .hasScrollEnabled(false)
                            .padding(0)
                            .background(Color.red)
                            .frame(width: geometry.size.width, height: 290, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        }
                        .frame(width: geometry.size.width)
                        .navigationTitle("Home")
                        
                    }
                    .fixFlickering { scrollView in
                        scrollView.background(Color.background)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(1)
            
            Text("setting")
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("setting")
                }
                .tag(2)
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
                .shadow(color: .primery, radius: 2, x: 0, y: 0.0)
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
