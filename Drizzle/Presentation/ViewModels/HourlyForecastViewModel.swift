//
//  HourlyForecastViewModel.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import SwiftUI
import Combine

class HourlyForecastViewModel: ObservableObject {
    @Published var hours: [HourlyForecast] = []

    init(day: ForecastDay) {
        self.hours = day.hours
    }
}
