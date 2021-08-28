//
//  Encodeable+extension.swift
//  Coconut
//
//  Created by sh on 8/28/21.
//

import Foundation


extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
