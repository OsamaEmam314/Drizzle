//
//  TimeHelpers.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation
import SwiftUI

struct TimeHelpers {
    static func isMorning() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 5 && hour < 18 
    }

    static func textColor() -> Color {
        return isMorning() ? .black : .white
    }

}
