//
//  CitySearchViewModel.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import Foundation
import SwiftUI
import Combine

class CitySearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredCities: [String] = []

    private let searchCitiesUseCase: SearchCitiesUseCase
    private var cancellables = Set<AnyCancellable>()

    init(searchCitiesUseCase: SearchCitiesUseCase) {
        self.searchCitiesUseCase = searchCitiesUseCase
        setupSearch()
    }

    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { query in
                self.searchCitiesUseCase.execute(query: query)
            }
            .assign(to: &$filteredCities)
    }
}
