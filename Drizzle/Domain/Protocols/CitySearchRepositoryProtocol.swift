//
//  CitySearchRepositoryProtocol.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import Foundation
import Combine

protocol CitySearchRepositoryProtocol {
    func searchCities(query: String) -> AnyPublisher<[String], Never>
    func getAllCities() -> AnyPublisher<[String], Never>
}
