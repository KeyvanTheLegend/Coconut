//
//  ChatView.swift
//  Coconut
//
//  Created by sh on 8/17/21.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    
                }.frame(maxWidth : .infinity)
            }.fixFlickering { scrollview in
                scrollview.background(Color.background)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
