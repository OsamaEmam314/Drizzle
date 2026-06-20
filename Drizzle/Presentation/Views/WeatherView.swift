import SwiftUI
import Kingfisher

struct WeatherView: View {
    @StateObject var viewModel: WeatherViewModel
    @StateObject private var historyViewModel: SearchHistoryViewModel

    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)

        let repository = WeatherRepository(
            remoteDataSource: RemoteWeatherDataSource(),
            localDataSource: LocalSearchDataSource(coreDataStack: CoreDataStack.shared)
        )
        let fetchRecentUseCase = FetchRecentSearchesUseCase(repository: repository)
        _historyViewModel = StateObject(wrappedValue: SearchHistoryViewModel(fetchRecentSearchesUseCase: fetchRecentUseCase))
    }

    var body: some View {
        let isMorning = TimeHelpers.isMorning()
        let textColor = isMorning ? Color.black : Color.white

        NavigationView {
            ZStack {
                // Background (use image if you have assets, else gradient)
                if isMorning {
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                                   startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                } else {
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.6)]),
                                   startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                }

                VStack(spacing: 16) {
                    // Search bar
                    HStack {
                        TextField("Enter city name", text: $viewModel.city, onCommit: {
                            viewModel.search()
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black) // always visible

                        Button("Search") {
                            viewModel.search()
                        }
                        .foregroundColor(textColor)
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal)

                    if viewModel.isLoading {
                        ProgressView().padding()
                    }

                    if let error = viewModel.errorMessage {
                        Text(error).foregroundColor(.red).padding()
                    }

                    if let weather = viewModel.weather {
                        ScrollView {
                            VStack(spacing: 20) {
                                // SECTION 1: Current weather
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

                                    // Today's max/min
                                    if let today = weather.forecast.first {
                                        HStack {
                                            Text("↑ \(today.maxTempC, specifier: "%.1f")°")
                                                .foregroundColor(.red)
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

                                // SECTION 2: 3-Day Forecast
                                VStack(alignment: .leading) {
                                    Text("3-DAY FORECAST")
                                        .font(.headline)
                                        .foregroundColor(textColor)
                                        .padding(.horizontal)

                                    ForEach(weather.forecast.indices, id: \.self) { index in
                                        let day = weather.forecast[index]
                                        NavigationLink(destination: HourlyForecastView(day: day)) {
                                            ForecastRow(day: day, textColor: textColor)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .padding(.horizontal)
                                        if index < weather.forecast.count - 1 {
                                            Divider().background(textColor.opacity(0.3))
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(16)

                                // SECTION 3: Bottom metrics
                                HStack(spacing: 16) {
                                    MetricView(label: "Visibility", value: "\(weather.current.visibilityKM, specifier: "%.1f") km", textColor: textColor)
                                    MetricView(label: "Humidity", value: "\(weather.current.humidity)%", textColor: textColor)
                                    MetricView(label: "Feels Like", value: "\(weather.current.feelsLikeCelsius, specifier: "%.1f")°", textColor: textColor)
                                    MetricView(label: "Pressure", value: "\(weather.current.pressureMB, specifier: "%.1f") mb", textColor: textColor)
                                }
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(16)
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Recent searches (optional, can be placed elsewhere)
                    VStack {
                        Divider().background(textColor.opacity(0.3))
                        SearchHistoryView(viewModel: historyViewModel)
                            .onAppear { historyViewModel.refresh() }
                            .onChange(of: viewModel.weather) { _ in
                                historyViewModel.refresh()
                            }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationBarHidden(true)
            .foregroundColor(textColor) // default for all text
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
                    .foregroundColor(.red)
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
