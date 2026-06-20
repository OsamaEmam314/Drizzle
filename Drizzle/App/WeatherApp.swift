//
//  WeatherApp.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import Foundation
import SwiftUI

@main
struct WeatherApp: App {
    let coreDataStack = CoreDataStack.shared
    let weatherRepository: WeatherRepositoryProtocol

    init() {
        let remoteDataSource = RemoteWeatherDataSource()
        let localDataSource = LocalSearchDataSource(coreDataStack: coreDataStack)
        weatherRepository = WeatherRepository(remoteDataSource: remoteDataSource,
                                              localDataSource: localDataSource)
    }

    var body: some Scene {
        WindowGroup {
            WeatherView(
                viewModel: WeatherViewModel(
                    fetchWeatherUseCase: FetchWeatherUseCase(repository: weatherRepository),
                    saveSearchUseCase: SaveSearchUseCase(repository: weatherRepository)
                )
            )
            .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
        }
    }
}
