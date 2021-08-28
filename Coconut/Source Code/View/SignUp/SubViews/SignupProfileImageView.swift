//
//  SignupProfileImageView.swift
//  Coconut
//
//  Created by sh on 8/27/21.
//

import SwiftUI

struct SignupProfileImageView : View{
    
    @ObservedObject var viewModel : SignupViewModel
    
    var body: some View {
        ZStack(alignment : .top){
            if viewModel.isImageSelected {
                Image(uiImage: viewModel.selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.primery)
                    .frame(width: 110, height: 110, alignment: .center)
                    .cornerRadius(12)
            }
            else{
            Image(systemName: "person.fill")
                .resizable()
                .foregroundColor(.primery)
                .frame(width: 60, height: 60, alignment: .center)
                .padding(25)
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
            }
            Image(systemName: "plus")
                .resizable()
                .foregroundColor(.primery)
                .frame(width: 20, height: 20, alignment: .center)
                .padding(8)
                .background(Color.whiteColor)
                .cornerRadius(8)
                .padding(.top , 95)
                .padding(.leading , 115)
        }
        .onTapGesture {
            viewModel.showImagePicker = true
        }
        .padding(.top,32)
        .padding(.bottom,32)
    }
}
