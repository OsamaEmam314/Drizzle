# Drizzle – Weather App

**Drizzle** is a beautifully designed weather application built with **SwiftUI** and **Clean Architecture**. It provides current weather conditions, a 3‑day forecast, and an hourly breakdown – all with a time‑sensitive theme that adapts to morning and evening.

---

## ✨ Features

- **Current Weather** – temperature, condition, high/low, and a set of metrics (visibility, humidity, feels‑like, pressure).
- **3‑Day Forecast** – today, tomorrow, and the day after with icons and min/max temperatures.
- **Hourly Forecast** – tap any day to see a scrollable list of hours with temperatures and weather icons.
- **City Search** – type to filter from a local list of cities (over 25 built‑in).
- **Recent Searches** – Core Data saves your last 10 searches as tappable chips.
- **Time‑Aware Theme** – morning (5 AM – 6 PM) uses a light blue gradient with black text; evening uses a rich purple‑blue gradient with white text.
- **Default City** – Cairo loads automatically on first launch.
- **Clean Architecture + MVVM** – well‑structured, testable, and scalable.

---

## 🛠 Tech Stack

| Layer        | Technology |
|--------------|------------|
| **UI**       | SwiftUI (iOS 14.5+) |
| **Networking** | Alamofire 5.4.4 |
| **Image Loading** | Kingfisher 7.0 |
| **Persistence** | Core Data |
| **Reactive** | Combine |
| **Architecture** | Clean Architecture + MVVM |

---

## 🏗 Architecture Overview

The project follows **Clean Architecture** principles with clear separation of concerns:

- **Domain** – Entities, Use Cases, and Repository Protocols (business logic).
- **Data** – Repository implementations, Data Sources (remote/local), DTOs, and Core Data stack.
- **Presentation** – SwiftUI Views and ViewModels (MVVM) that interact with Use Cases via Combine.

This makes the codebase modular, testable, and easy to maintain.

---

## 📁 Project Structure

```
Drizzle/
├── AppDelegate.swift 
├── SceneDelegate.swift 
├── ContentView.swift 
├── Info.plist
├── Drizzle.xcdatamodeld 
├── Resources/
│ └── cities.json 
├── Domain/
│ ├── Entities/
│ │ └── Weather.swift
│ ├── UseCases/
│ │ ├── FetchWeatherUseCase.swift
│ │ ├── SaveSearchUseCase.swift
│ │ ├── FetchRecentSearchesUseCase.swift
│ │ └── SearchCitiesUseCase.swift
│ └── Protocols/
│ ├── WeatherRepositoryProtocol.swift
│ └── CitySearchRepositoryProtocol.swift
├── Data/
│ ├── Repositories/
│ │ ├── WeatherRepository.swift
│ │ └── CitySearchRepository.swift
│ ├── DataSources/
│ │ ├── RemoteWeatherDataSource.swift
│ │ ├── LocalSearchDataSource.swift
│ │ └── LocalCityDataSource.swift
│ ├── DTOs/
│ │ └── WeatherDTO.swift
│ └── CoreData/
│ ├── CoreDataStack.swift
│ └── SearchHistoryEntity+CoreDataProperties.swift
├── Presentation/
│ ├── ViewModels/
│ │ ├── WeatherViewModel.swift
│ │ ├── CitySearchViewModel.swift
│ │ ├── SearchHistoryViewModel.swift
│ │ └── HourlyForecastViewModel.swift
│ └── Views/
│ ├── WeatherView.swift
│ └── HourlyForecastView.swift
└── Utils/
├── TimeHelpers.swift
```

---

## 🚀 Getting Started

### Prerequisites

- **Xcode 12.5.1** or later (iOS 14.5+)
- **Swift Package Manager** (SPM) for dependencies
 **Add SPM dependencies** (if not already resolved)
   - **Alamofire**: `https://github.com/Alamofire/Alamofire` (version 5.6.4)
   - **Kingfisher**: `https://github.com/onevcat/Kingfisher` (version 7.0.0)

---

## 🎯 Features in Detail

### Search & Recent Searches
- Type in the search bar – matching cities from the local list appear below.
- Tap a city to fetch its weather.
- Recent searches are stored in Core Data and appear as horizontal chips when the search bar is empty.

### Weather Display
- **Current Section**: City name, temperature, condition, high/low for today.
- **3‑Day Forecast**: List of days with icons and min/max temps. Tap any day to see the hourly forecast.
- **Metrics**: Visibility, humidity, feels‑like, and pressure.

### Hourly Forecast
- Shows all hours for the selected day.
- For today, it starts from the current hour; for future days, all 24 hours are shown.
- Each row displays the time (e.g., “7 pm”), weather icon, and temperature.

### Time‑Adaptive Theme
- **Morning (5 AM – 6 PM)**: Light blue gradient with black text.
- **Evening (6 PM – 5 AM)**: Deep purple‑blue gradient with white text.
- The theme applies to the main screen, hourly view, and all components.

---
