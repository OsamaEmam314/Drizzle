//
//  Weather.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation

struct Weather {
    let city: String
    let current: CurrentWeather
    let forecast: [ForecastDay]
}

struct CurrentWeather {
    let temperatureCelsius: Double
    let condition: String
    let iconURL: URL?
    let feelsLikeCelsius: Double
    let humidity: Int
    let pressureMB: Double
    let visibilityKM: Double
}

struct ForecastDay {
    let date: Date
    let maxTempC: Double
    let minTempC: Double
    let condition: String
    let iconURL: URL?
    let hours: [HourlyForecast]
}

struct HourlyForecast {
    let time: Date
    let temperatureCelsius: Double
    let condition: String
    let iconURL: URL?
}
