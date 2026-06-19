//
//  Extensions.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation

extension URL {
    init?(safeString: String) {
        let fixed = safeString.hasPrefix("http") ? safeString : "https:" + safeString
        self.init(string: fixed)
    }
}
