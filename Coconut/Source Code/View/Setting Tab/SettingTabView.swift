//
//  SettingTabView.swift
//  Coconut
//
//  Created by sh on 8/22/21.
//

import SwiftUI

struct SettingTabView: View {
    var body: some View {
        NavigationView{
            ScrollView {
                VStack {
                    SettingTabHeaderView()
                    Divider()
                    
                    HStack(alignment : .center){
                        VStack (alignment : .center){
                        Image("memoji1")
                            .resizable()
                            .foregroundColor(.primery)
                            .imageScale(.medium)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4)

                        Text("Avatar")
                            .font(.title3)
                            .foregroundColor(.whiteColor)
                        Spacer()
                    }
                    Divider()
                    HStack(alignment : .center){
                        VStack (alignment : .center){
                        Image(systemName: "person.2.fill")
                            .resizable()
                            .foregroundColor(.primery)
                            .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4)

                        Text("Friends")
                            .font(.title3)
                            .foregroundColor(.whiteColor)
                        Spacer()
                    }
                    Divider()
                    HStack(alignment : .center){
                        VStack (alignment : .center){
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .foregroundColor(.primery)
                            .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4)

                        Text("Interests")
                            .font(.title3)
                            .foregroundColor(.whiteColor)
                        Spacer()
                    }
                    Divider()
                    HStack(alignment : .center){
                        VStack (alignment : .center){
                        Image(systemName: "info")
                            .resizable()
                            .foregroundColor(.primery)
                            .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4)
                        
                        Text("Bio")
                            .font(.title3)
                            .foregroundColor(.whiteColor)
                        Spacer()
                    }
                    Divider()

                }
                .frame(maxWidth : .infinity)
                .padding(.top,16)
            }
            .fixFlickering()
            .background(Color.background
                            .ignoresSafeArea())
            .navigationBarTitle("Setting")
        }
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}
struct SettingTabHeaderView : View {
    var body: some View{
        HStack(alignment : .top){
            Text("🥥")
                .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.primery)
                .cornerRadius(12)
                .font(.title)
                .padding(.horizontal ,16)
            VStack(alignment : .leading){
                Text("Keyvan Yaghoubian")
                    .foregroundColor(.white)
                    .padding(.top , 10)
                    .font(.title3)
                Text("+98 9374397796")
                    .foregroundColor(.gray)
                    .padding(.vertical , 4)
                    .font(.body)
                
            }
            Spacer()
        }
    }
}
