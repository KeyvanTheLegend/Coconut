//
//  String+extension.swift
//  Coconut
//
//  Created by sh on 8/29/21.
//

import Foundation

extension String {
     func safeString() -> String {
        var safeString = self.replacingOccurrences(of: "@", with: "-")
        safeString =  safeString.replacingOccurrences(of: ".", with: "-")
        safeString = safeString.lowercased()
        safeString = safeString.capitalizeFirstLetter
        return safeString
    }
}
extension String {
      var capitalizeFirstLetter:String {
           return self.prefix(1).capitalized + dropFirst()
      }
 }
