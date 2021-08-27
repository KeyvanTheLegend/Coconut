//
//  SignupProfileImageView.swift
//  Coconut
//
//  Created by sh on 8/27/21.
//

import SwiftUI

struct SignupProfileImageView : View{
    var body: some View {
        ZStack(alignment : .top){
            Image(systemName: "person.fill")
                .resizable()
                .foregroundColor(.primery)
                .frame(width: 50, height: 50, alignment: .center)
                .padding(20)
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
            Image(systemName: "plus")
                .resizable()
                .foregroundColor(.primery)
                .frame(width: 20, height: 20, alignment: .center)
                .padding(8)
                .background(Color.whiteColor)
                .cornerRadius(8)
                .padding(.top , 70)
                .padding(.leading , 90)
        }
        .padding(.top,32)
        .padding(.bottom,32)
    }
}
