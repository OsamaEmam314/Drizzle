//
//  SaveSearchUseCase.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation
import Combine

class SaveSearchUseCase {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func execute(city: String) -> AnyPublisher<Void, Error> {
        return repository.saveSearch(city: city)
    }
}
