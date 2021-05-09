//
//  StringExtension.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation

extension String {
  func stringByAddingPercentEncodingForRFC3986() -> String? {
    let unreserved = "-._~/?"
    let allowed = NSMutableCharacterSet.alphanumeric()
    allowed.addCharacters(in: unreserved)
    return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
  }
}

extension CharacterSet {
    static let allowedCharacters = urlQueryAllowed.subtracting(.init(charactersIn: "+"))
}
