import SwiftUI
import Combine

class HourlyForecastViewModel: ObservableObject {
    @Published var hours: [HourlyForecast] = []

    init(day: ForecastDay) {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDate(day.date, inSameDayAs: now) {
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
            let startOfCurrentHour = calendar.date(from: components) ?? now

            self.hours = day.hours.filter { $0.time >= startOfCurrentHour }

            print("Today: showing \(self.hours.count) hours from \(self.hours.first?.time ?? Date())")
        } else {
            self.hours = day.hours

            print("Other day: showing \(self.hours.count) hours")
        }
    }
}
