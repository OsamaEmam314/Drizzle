//
//  LocalWeatherDataWeather.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation
import Combine
import CoreData

class LocalSearchDataSource {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    func saveSearch(city: String) -> AnyPublisher<Void, Error> {
            Future { promise in
                let context = self.coreDataStack.viewContext
                let entity = SearchHistory(context: context)
                entity.cityName = city
                entity.timeStamp = Date()

                do {
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
            .eraseToAnyPublisher()
        }
    
    func fetchRecentSearches() -> AnyPublisher<[String], Error> {
           Future { promise in
               let context = self.coreDataStack.viewContext
               let request: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
               request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
               request.fetchLimit = 10
               do {
                   let results = try context.fetch(request)
                   let cities = results.compactMap { $0.cityName }
                   promise(.success(cities))
               } catch {
                   promise(.failure(error))
               }
           }
           .eraseToAnyPublisher()
       }
}
