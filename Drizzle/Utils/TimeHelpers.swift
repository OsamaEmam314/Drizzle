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

    static func isEvening() -> Bool {
        return !isMorning()
    }

    static func backgroundImageName() -> String {
        return isMorning() ? "morning_bg" : "evening_bg"
    }

    static func textColor() -> Color {
        return isMorning() ? .black : .white
    }

    static func backgroundColor() -> Color {
        return isMorning() ? Color(red: 0.8, green: 0.9, blue: 1.0) : Color(red: 0.1, green: 0.1, blue: 0.2)
    }
}
