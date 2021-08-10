//
//  MustMeetsContentView.swift
//  Coconut
//
//  Created by sh on 8/10/21.
//

import SwiftUI

struct MustMeetsContentView : View {
    
    var profileImage : String
    var name : String
    var matchPercentage : CGFloat
    
    private var matchPercentageString : String {
        return ("\(Int(matchPercentage*100))% Match")
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            HStack(content: {
                
                Image(profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70,
                           height: 70,
                           alignment: .center)
                    .cornerRadius(12)
                    .padding([.trailing],16)
                    .padding([.bottom,.top],0)
                    .clipped()
                
                VStack (alignment: .leading, spacing: 6, content: {
                    
                    Text(name)
                        .foregroundColor(.white)
                        .font(.title3.weight(.medium))
                    
                    HStack{
                        
                        HStack{}
                            .frame(width: abs((geometry.size.width - (70+134)) * matchPercentage), height:6, alignment: .center)
                            .background(Color.primery)
                            .cornerRadius(3)
                            .padding([.trailing],4)
                        
                        Text(matchPercentageString)
                            .font(.caption)
                            .foregroundColor(Color.primery)
                        
                    }
                })
                .frame(width: geometry.size.width,
                       height: geometry.size.height,
                       alignment: .leading)
            })
        }
    }
}
