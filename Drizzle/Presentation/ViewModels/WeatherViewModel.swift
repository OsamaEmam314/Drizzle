//
//  WeatherViewModel.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import Foundation
import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var weather: Weather?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchWeatherUseCase: FetchWeatherUseCase
    private let saveSearchUseCase: SaveSearchUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchWeatherUseCase: FetchWeatherUseCase,
         saveSearchUseCase: SaveSearchUseCase) {
        self.fetchWeatherUseCase = fetchWeatherUseCase
        self.saveSearchUseCase = saveSearchUseCase
    }

    func search() {
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        isLoading = true
        errorMessage = nil

        fetchWeatherUseCase.execute(city: city)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] weather in
                self?.weather = weather
                self?.saveSearch(city: weather.city)
            }
            .store(in: &cancellables)
    }

    private func saveSearch(city: String) {
        saveSearchUseCase.execute(city: city)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
