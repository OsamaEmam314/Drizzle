//
//  CitySearchViewModel.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import SwiftUI
import Combine

class CitySearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredCities: [String] = []

    private let searchCitiesUseCase: SearchCitiesUseCase
    private var cancellables = Set<AnyCancellable>()

    init(searchCitiesUseCase: SearchCitiesUseCase) {
        self.searchCitiesUseCase = searchCitiesUseCase
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { self.searchCitiesUseCase.execute(query: $0) }
            .assign(to: &$filteredCities)
    }
}
