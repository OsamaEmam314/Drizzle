import Combine
import Foundation

class WeatherRepository: WeatherRepositoryProtocol {
    private let remoteDataSource: RemoteWeatherDataSource
    private let localDataSource: LocalSearchDataSource

    init(remoteDataSource: RemoteWeatherDataSource,
         localDataSource: LocalSearchDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetchWeather(for city: String) -> AnyPublisher<Weather, Error> {
        return remoteDataSource.fetchWeather(for: city)
            .map { response -> Weather in
                let current = CurrentWeather(
                    temperatureCelsius: response.current.tempC,
                    condition: response.current.condition.text,
                    iconURL: URL(string: "https:" + response.current.condition.icon),
                    feelsLikeCelsius: response.current.feelslikeC,
                    humidity: response.current.humidity,
                    pressureMB: response.current.pressureMB,
                    visibilityKM: response.current.visKM
                )

                let forecast = response.forecast.forecastday.map { dto -> ForecastDay in
                    let date = Self.dateFromString(dto.date) ?? Date()
                    let iconURL = URL(string: "https:" + dto.day.condition.icon)

                    let hours = dto.hour.map { hourDTO -> HourlyForecast in
                        let time = Self.dateFromFullString(hourDTO.time) ?? Date()
                        let iconURL = URL(string: "https:" + hourDTO.condition.icon)
                        return HourlyForecast(
                            time: time,
                            temperatureCelsius: hourDTO.tempC,
                            condition: hourDTO.condition.text,
                            iconURL: iconURL
                        )
                    }

                    return ForecastDay(
                        date: date,
                        maxTempC: dto.day.maxtempC,
                        minTempC: dto.day.mintempC,
                        condition: dto.day.condition.text,
                        iconURL: iconURL,
                        hours: hours
                    )
                }

                return Weather(city: response.location.name, current: current, forecast: forecast)
            }
            .eraseToAnyPublisher()
    }

    private static func dateFromString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }

    private static func dateFromFullString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: string)
    }

    func saveSearch(city: String) -> AnyPublisher<Void, Error> {
        return localDataSource.saveSearch(city: city)
    }

    func fetchRecentSearches() -> AnyPublisher<[String], Error> {
        return localDataSource.fetchRecentSearches()
    }
}
