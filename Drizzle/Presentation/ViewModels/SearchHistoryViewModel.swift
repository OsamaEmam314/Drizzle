//
//  SearchHistoryViewModel.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import SwiftUI
import Combine

class SearchHistoryViewModel: ObservableObject {
    @Published var recentSearches: [String] = []

    private let fetchRecentSearchesUseCase: FetchRecentSearchesUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchRecentSearchesUseCase: FetchRecentSearchesUseCase) {
        self.fetchRecentSearchesUseCase = fetchRecentSearchesUseCase
        loadHistory()
    }

    func loadHistory() {
        fetchRecentSearchesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] cities in
                self?.recentSearches = cities
            }
            .store(in: &cancellables)
    }

    func refresh() { loadHistory() }
}
