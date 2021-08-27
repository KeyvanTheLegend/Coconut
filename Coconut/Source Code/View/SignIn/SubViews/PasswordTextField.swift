//
//  PasswordTextField.swift
//  Coconut
//
//  Created by sh on 8/27/21.
//

import SwiftUI

/// SecureField for passwords used in **Signup View** and **Signin View** 
struct PasswordTextField : View {
    
    @Binding var password :String
    
    var body: some View {
        HStack(alignment: .center, spacing: 24, content: {
            Spacer()
            SecureField("", text : $password)
                .placeholder(
                    when: password.isEmpty,
                    alignment: .center,
                    placeholder: {
                        Text("Password")
                            .foregroundColor(Color.white)
                    }
                )
                .foregroundColor(.white)
                .padding(.horizontal,32)
                .padding(.vertical, 16)
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
                .textContentType(.password)
                .padding(.bottom, 32)
            Spacer()
        })
    }
}
