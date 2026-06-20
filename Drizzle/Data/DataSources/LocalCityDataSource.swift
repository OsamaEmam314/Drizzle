//
//  LocalCityDataSource.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import Foundation
import Combine

class LocalCityDataSource {
    private var allCities: [String] = []

    init() {
        loadCities()
    }

    private func loadCities() {
        guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else {
            allCities = ["London", "New York", "Paris", "Tokyo"]
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let cities = try JSONDecoder().decode([String].self, from: data)
            allCities = cities
        } catch {
            print("Failed to load cities: \(error)")
            allCities = ["London", "New York", "Paris", "Tokyo"]
        }
    }

    func searchCities(query: String) -> AnyPublisher<[String], Never> {
        let filtered = allCities.filter { $0.localizedCaseInsensitiveContains(query) }
        return Just(filtered).eraseToAnyPublisher()
    }

    func getAllCities() -> AnyPublisher<[String], Never> {
        return Just(allCities).eraseToAnyPublisher()
    }
}
