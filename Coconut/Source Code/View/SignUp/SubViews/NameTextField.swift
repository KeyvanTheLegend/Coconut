//
//  NameTextField.swift
//  Coconut
//
//  Created by sh on 8/27/21.
//

import SwiftUI

struct NameTextField: View {
    
    @Binding var name : String
    
    var body : some View {
        HStack(alignment: .center, spacing: 24, content: {
            Spacer()
            TextField("", text : $name)
                .placeholder(when: name.isEmpty ,alignment: .center, placeholder: {
                    Text("Name")
                        .foregroundColor(Color.white)
                })
                .padding([.leading,.trailing],32)
                .padding([.bottom,.top], 16)
                .foregroundColor(.white)
                .background(Color.whiteColor.opacity(0.2))
                .cornerRadius(8)
                .font(
                    .system(
                        size: 16,
                        weight: .regular,
                        design: .monospaced
                    )
                )
                .multilineTextAlignment(.center)
            Spacer()
        })
        .padding(.bottom , 16)
    }
}
