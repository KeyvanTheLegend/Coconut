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
                    Divider()
                }
                .frame(maxWidth : .infinity)
                .padding(.top,16)
            }
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
