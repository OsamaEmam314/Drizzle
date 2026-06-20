//
//  HourlyForecastViewModel.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import Foundation
import SwiftUI
import Combine

class HourlyForecastViewModel: ObservableObject {
    @Published var hours: [HourlyForecast] = []

    init(day: ForecastDay) {
        let now = Date()
        let filtered = day.hours.filter { $0.time >= now }
        self.hours = filtered
    }
}
