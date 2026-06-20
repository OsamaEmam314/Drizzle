import SwiftUI
import Kingfisher

struct HourlyForecastView: View {
    let day: ForecastDay
    @StateObject var viewModel: HourlyForecastViewModel

    init(day: ForecastDay) {
        self.day = day
        _viewModel = StateObject(wrappedValue: HourlyForecastViewModel(day: day))
    }

    var body: some View {
        let textColor = TimeHelpers.textColor()

        ZStack {
            if TimeHelpers.isMorning() {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            } else {
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 0.15, green: 0.05, blue: 0.25),
                    Color(red: 0.05, green: 0.05, blue: 0.20)
                ]),
                startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }

            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Hourly Forecast")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(textColor)

                    Text(day.date, style: .date)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(textColor.opacity(0.8))
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 20)

                if viewModel.hours.isEmpty {
                    Spacer()
                    Text("No hourly data available for this day")
                        .foregroundColor(textColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.hours, id: \.time) { hour in
                                HourRow(hour: hour, textColor: textColor)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HourRow: View {
    let hour: HourlyForecast
    let textColor: Color

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h a"
        return formatter.string(from: hour.time).lowercased()
    }

    var body: some View {
        HStack(spacing: 16) {
            Text(timeString)
                .font(.headline)
                .frame(width: 65, alignment: .leading)
                .foregroundColor(textColor)

            if let iconURL = hour.iconURL {
                KFImage(iconURL)
                    .placeholder { ProgressView() }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            } else {
                Image(systemName: "cloud.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundColor(textColor.opacity(0.6))
            }

            Spacer()

            Text("\(hour.temperatureCelsius, specifier: "%.0f")°")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(textColor.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(textColor.opacity(0.15), lineWidth: 1)
        )
    }
}
