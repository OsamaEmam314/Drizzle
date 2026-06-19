//
//  WeatherDTO.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation

struct WeatherResponse: Decodable {
    let location: Location
    let current: CurrentDTO
    let forecast: ForecastContainer
}

struct Location: Decodable {
    let name: String
}

struct CurrentDTO: Decodable {
    let tempC: Double
    let condition: Condition
    let feelslikeC: Double
    let humidity: Int
    let pressureMB: Double
    let visKM: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case feelslikeC = "feelslike_c"
        case humidity
        case pressureMB = "pressure_mb"
        case visKM = "vis_km"
    }
}

struct ForecastContainer: Decodable {
    let forecastday: [ForecastDayDTO]
}

struct ForecastDayDTO: Decodable {
    let date: String
    let day: DayDetails
    let hour: [HourDTO]
}

struct DayDetails: Decodable {
    let maxtempC: Double
    let mintempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
    }
}

struct HourDTO: Decodable {
    let time: String
    let tempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case condition
    }
}

struct Condition: Decodable {
    let text: String
    let icon: String     
}
