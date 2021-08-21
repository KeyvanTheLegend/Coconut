//
//  TextField+extension.swift
//  SpotiFriends
//
//  Created by sh on 8/3/21.
//

import Foundation
import SwiftUI


extension View {
    
    /// Addes Placeholder to TextFields
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
