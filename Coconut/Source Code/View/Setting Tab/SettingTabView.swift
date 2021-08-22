//
//  SettingTabView.swift
//  Coconut
//
//  Created by sh on 8/22/21.
//

import SwiftUI

struct SettingTabView: View {
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment : .center){
                    Text("🥥")
                        .frame(width: 90, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color.primery)
                        .cornerRadius(45)
                        .font(.title)
                    Text("Keyvan Yaghoubian")
                        .foregroundColor(.white)
                        .padding(.top , 8)
                        .font(.title2)
                    Text("+98 9374397796")
                        .foregroundColor(.gray)
                        .padding(.vertical , 8)
                    
                }
                Divider()
            }
            .frame(maxWidth : .infinity)
        }
        .background(Color.background
        .ignoresSafeArea())
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}
