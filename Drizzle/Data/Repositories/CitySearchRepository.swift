//
//  CitySearchRepository.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import Foundation
import Combine

class CitySearchRepository: CitySearchRepositoryProtocol {
    private let localDataSource: LocalCityDataSource

    init(localDataSource: LocalCityDataSource) {
        self.localDataSource = localDataSource
    }

    func searchCities(query: String) -> AnyPublisher<[String], Never> {
        return localDataSource.searchCities(query: query)
    }

    func getAllCities() -> AnyPublisher<[String], Never> {
        return localDataSource.getAllCities()
    }
}
