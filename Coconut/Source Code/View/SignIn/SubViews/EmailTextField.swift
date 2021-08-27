//
//  EmailTextField.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/27/21.
//

import SwiftUI

/// TextField for email used in **Signup View** and **Signin View**
struct EmailTextField: View {
    
    @Binding var email  : String
    
    var body : some View {
        HStack(alignment: .center, spacing: 24, content: {
            Spacer()
            TextField("", text : $email)
                .placeholder(
                    when: email.isEmpty,
                    alignment: .center,
                    placeholder: {
                        Text("Email")
                            .foregroundColor(Color.white)
                    }
                )
                .padding([.horizontal],32)
                .padding([.vertical], 16)
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
        .padding(.bottom,16)
    }
}
