//
//  SearchCitiesUseCase .swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import Foundation
import Combine

class SearchCitiesUseCase {
    private let repository: CitySearchRepositoryProtocol

    init(repository: CitySearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) -> AnyPublisher<[String], Never> {
        guard !query.isEmpty else {
            return repository.getAllCities()
        }
        
        return repository.searchCities(query: query)
    }
}
