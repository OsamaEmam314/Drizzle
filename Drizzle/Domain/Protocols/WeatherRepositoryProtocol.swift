//
//  WeatherRepositoryProtocol.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation
import Combine

protocol WeatherRepositoryProtocol {
    func fetchWeather(for city: String) -> AnyPublisher<Weather, Error>
    func saveSearch(city: String) -> AnyPublisher<Void, Error>
    func fetchRecentSearches() -> AnyPublisher<[String], Error>
}
