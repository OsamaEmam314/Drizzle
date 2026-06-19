//
//  FetchRecentSearchesUseCase.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation
import Combine

class FetchRecentSearchesUseCase{
    private let repository: WeatherRepositoryProtocol
    
    init(repository: WeatherRepositoryProtocol){
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[String], Error> {
        return repository.fetchRecentSearches()
    }
}
