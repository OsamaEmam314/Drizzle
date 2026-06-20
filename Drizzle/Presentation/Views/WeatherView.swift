//
//  WeatherView.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

import SwiftUI
import Kingfisher

struct WeatherView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    @ObservedObject var citySearchViewModel: CitySearchViewModel
    @ObservedObject var searchHistoryViewModel: SearchHistoryViewModel

    var body: some View {
        let isMorning = TimeHelpers.isMorning()
        let textColor = isMorning ? Color.black : Color.white

        NavigationView {
            ZStack {
                BackgroundView(isMorning: isMorning)

                VStack(spacing: 16) {
                    SearchBarView(
                        searchText: $citySearchViewModel.searchText,
                        isLoading: weatherViewModel.isLoading,
                        textColor: textColor,
                        onSearch: {
                            if !citySearchViewModel.searchText.isEmpty {
                                weatherViewModel.search(city: citySearchViewModel.searchText)
                            }
                        }
                    )

                    LoadingAndErrorView(
                        isLoading: weatherViewModel.isLoading,
                        errorMessage: weatherViewModel.errorMessage
                    )

                    if !citySearchViewModel.searchText.isEmpty {
                        CitySearchResultsView(
                            cities: citySearchViewModel.filteredCities,
                            textColor: textColor,
                            onSelect: { city in
                                weatherViewModel.search(city: city)
                                citySearchViewModel.searchText = ""
                            }
                        )
                    }

                    if citySearchViewModel.searchText.isEmpty {
                        RecentSearchesView(
                            recentSearches: searchHistoryViewModel.recentSearches,
                            textColor: textColor,
                            onSelect: { city in
                                weatherViewModel.search(city: city)
                            }
                        )
                        .onAppear { searchHistoryViewModel.refresh() }
                        .onChange(of: weatherViewModel.weather?.city) { _ in
                            searchHistoryViewModel.refresh()
                        }
                    }

                    if let weather = weatherViewModel.weather {
                        WeatherContentView(weather: weather, textColor: textColor)
                    } else {
                        PlaceholderView(textColor: textColor)
                    }

                    Spacer()
                }
                .padding(.top)
            }
            .navigationBarHidden(true)
            .foregroundColor(textColor)
            .onAppear {
                if weatherViewModel.weather == nil && searchHistoryViewModel.recentSearches.isEmpty {
                    weatherViewModel.search(city: "Cairo")
                }
            }
        }
    }
}


struct BackgroundView: View {
    let isMorning: Bool
    var body: some View {
        if isMorning {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        } else {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.6)]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    let isLoading: Bool
    let textColor: Color
    let onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search city...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(8)
            Button("Search", action: onSearch)
                .foregroundColor(textColor)
                .disabled(isLoading)
        }
        .padding(.horizontal)
    }
}

struct LoadingAndErrorView: View {
    let isLoading: Bool
    let errorMessage: String?
    var body: some View {
        Group {
            if isLoading { ProgressView().padding() }
            if let error = errorMessage { Text(error).foregroundColor(.red).padding() }
        }
    }
}

struct CitySearchResultsView: View {
    let cities: [String]
    let textColor: Color
    let onSelect: (String) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(cities, id: \.self) { city in
                    Button(action: { onSelect(city) }) {
                        Text(city)
                            .foregroundColor(textColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                    }
                    
                    Divider()
                        .background(textColor.opacity(0.3))
                }
            }
        }
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .frame(height: min(CGFloat(cities.count * 44), 200))
    }
}
struct RecentSearchesView: View {
    let recentSearches: [String]
    let textColor: Color
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Searches")
                .font(.headline)
                .foregroundColor(textColor)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(recentSearches, id: \.self) { city in
                        Button(action: { onSelect(city) }) {
                            Text(city)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)
                                .foregroundColor(textColor)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 44)
        }
    }
}

struct WeatherContentView: View {
    let weather: Weather
    let textColor: Color

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CurrentWeatherSection(weather: weather, textColor: textColor)
                ForecastSection(forecast: weather.forecast, textColor: textColor)
                MetricsSection(
                    visibility: weather.current.visibilityKM,
                    humidity: weather.current.humidity,
                    feelsLike: weather.current.feelsLikeCelsius,
                    pressure: weather.current.pressureMB,
                    textColor: textColor
                )
            }
            .padding(.horizontal)
        }
    }
}

struct CurrentWeatherSection: View {
    let weather: Weather
    let textColor: Color

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(weather.city)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(textColor)

            if let iconURL = weather.current.iconURL {
                KFImage(iconURL)
                    .placeholder { ProgressView() }
                    .resizable()
                    .frame(width: 64, height: 64)
            }

            Text("\(weather.current.temperatureCelsius, specifier: "%.1f")°C")
                .font(.system(size: 48, weight: .thin))
                .foregroundColor(textColor)

            Text(weather.current.condition)
                .font(.headline)
                .foregroundColor(textColor.opacity(0.8))

            if let today = weather.forecast.first {
                HStack {
                    Text("↑ \(today.maxTempC, specifier: "%.1f")°")
                        .foregroundColor(.orange)
                    Text("↓ \(today.minTempC, specifier: "%.1f")°")
                        .foregroundColor(.blue)
                }
                .font(.subheadline)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.2))
        .cornerRadius(16)
    }
}

struct ForecastSection: View {
    let forecast: [ForecastDay]
    let textColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text("3-DAY FORECAST")
                .font(.headline)
                .foregroundColor(textColor)
                .padding(.horizontal)

            ForEach(forecast.indices, id: \.self) { index in
                let day = forecast[index]
                NavigationLink(destination: HourlyForecastView(day: day)) {
                    ForecastRow(day: day, textColor: textColor)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
                if index < forecast.count - 1 {
                    Divider().background(textColor.opacity(0.3))
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
    }
}

struct MetricsSection: View {
    let visibility: Double
    let humidity: Int
    let feelsLike: Double
    let pressure: Double
    let textColor: Color

    var body: some View {
        HStack(spacing: 16) {
            MetricView(label: "Visibility", value: String(format: "%.1f km", visibility), textColor: textColor)
            MetricView(label: "Humidity", value: "\(humidity)%", textColor: textColor)
            MetricView(label: "Feels Like", value: String(format: "%.1f°", feelsLike), textColor: textColor)
            MetricView(label: "Pressure", value: String(format: "%.1f mb", pressure), textColor: textColor)
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
    }
}

struct PlaceholderView: View {
    let textColor: Color
    var body: some View {
        VStack {
            Spacer()
            Text("Search for a city to see weather")
                .foregroundColor(textColor.opacity(0.6))
                .padding()
            Spacer()
        }
    }
}

struct ForecastRow: View {
    let day: ForecastDay
    let textColor: Color

    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: day.date)
    }

    var body: some View {
        HStack {
            Text(dayName)
                .font(.headline)
                .frame(width: 100, alignment: .leading)
                .foregroundColor(textColor)

            if let iconURL = day.iconURL {
                KFImage(iconURL)
                    .placeholder { ProgressView() }
                    .resizable()
                    .frame(width: 32, height: 32)
            }

            Spacer()

            HStack(spacing: 8) {
                Text("\(day.minTempC, specifier: "%.1f")°")
                    .foregroundColor(.blue)
                Text("-")
                    .foregroundColor(textColor)
                Text("\(day.maxTempC, specifier: "%.1f")°")
                    .foregroundColor(.orange)     
            }
            .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

struct MetricView: View {
    let label: String
    let value: String
    let textColor: Color

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(textColor.opacity(0.7))
            Text(value)
                .font(.headline)
                .foregroundColor(textColor)
        }
        .frame(maxWidth: .infinity)
    }
}
