//
//  ContentView.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import SwiftUI

struct ContentView: View {
    let coreDataStack = CoreDataStack.shared

    let weatherViewModel: WeatherViewModel
    let citySearchViewModel: CitySearchViewModel
    let searchHistoryViewModel: SearchHistoryViewModel

    init() {
        // ─── Weather Repository ──────────────────────────────
        let remoteDataSource = RemoteWeatherDataSource()
        let localDataSource = LocalSearchDataSource(coreDataStack: coreDataStack)
        let weatherRepository = WeatherRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )

        // ─── Weather ViewModel ───────────────────────────────
        let fetchWeatherUseCase = FetchWeatherUseCase(repository: weatherRepository)
        let saveSearchUseCase = SaveSearchUseCase(repository: weatherRepository)
        weatherViewModel = WeatherViewModel(
            fetchWeatherUseCase: fetchWeatherUseCase,
            saveSearchUseCase: saveSearchUseCase
        )

        // ─── Search History ViewModel ────────────────────────
        let fetchRecentUseCase = FetchRecentSearchesUseCase(repository: weatherRepository)
        searchHistoryViewModel = SearchHistoryViewModel(
            fetchRecentSearchesUseCase: fetchRecentUseCase
        )

        // ─── City Search Repository ──────────────────────────
        let localCityDataSource = LocalCityDataSource()
        let citySearchRepository = CitySearchRepository(localDataSource: localCityDataSource)
        let searchCitiesUseCase = SearchCitiesUseCase(repository: citySearchRepository)

        // ─── City Search ViewModel ───────────────────────────
        citySearchViewModel = CitySearchViewModel(
            searchCitiesUseCase: searchCitiesUseCase
        )
    }

    var body: some View {
        WeatherView(
            weatherViewModel: weatherViewModel,
            citySearchViewModel: citySearchViewModel,
            searchHistoryViewModel: searchHistoryViewModel
        )
        .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
    }
}
