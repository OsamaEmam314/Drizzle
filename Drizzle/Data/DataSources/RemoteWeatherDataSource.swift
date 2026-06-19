//
//  RemoteWeatherDataSource.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation
import Combine
import Alamofire

class RemoteWeatherDataSource{
    private let baseURL = "https://api.weatherapi.com/v1"
    private let apiKey = "3c9cfe70eaec44f2ada113137261906"
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        let url = "\(baseURL)/forecast.json"
        let parameters: Parameters = [
            "key": apiKey,
            "q": city,
            "days": 3
        ]
        return AF.request(url, parameters: parameters)
            .publishDecodable(type: WeatherResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
