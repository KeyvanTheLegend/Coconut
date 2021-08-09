//
//  List+extension.swift
//  Coconut
//
//  Created by sh on 8/9/21.
//

import SwiftUI

extension View {
    
    func hasScrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
}
