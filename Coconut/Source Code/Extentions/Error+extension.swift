//
//  Error+extension.swift
//  Coconut
//
//  Created by sh on 8/28/21.
//

import Foundation

extension Error {
    var code : Int {
        guard let code = (self as NSError?)?.code else {return 0}
        return code
    }
}
