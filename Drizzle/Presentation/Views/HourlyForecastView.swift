//
//  HourlyForecastView.swift
//  Drizzle
//
//  Created by Osama Khaled on 20/06/2026.
//

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
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.6)]),
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Hourly Forecast")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .padding(.top)

                Text(day.date, style: .date)
                    .font(.headline)
                    .foregroundColor(textColor.opacity(0.8))

                if viewModel.hours.isEmpty {
                    VStack {
                        Spacer()
                        Text("No hourly data available for this day")
                            .foregroundColor(textColor)
                            .padding()
                        Spacer()
                    }
                } else {
                    List(viewModel.hours, id: \.time) { hour in
                        HourRow(hour: hour, textColor: textColor)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .foregroundColor(textColor)
    }
}

struct HourRow: View {
    let hour: HourlyForecast
    let textColor: Color

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: hour.time).lowercased()
    }

    var body: some View {
        HStack {
            Text(timeString)
                .font(.headline)
                .frame(width: 60, alignment: .leading)
                .foregroundColor(textColor)

            if let iconURL = hour.iconURL {
                KFImage(iconURL)
                    .placeholder { ProgressView() }
                    .resizable()
                    .frame(width: 32, height: 32)
            }

            Spacer()

            Text("\(hour.temperatureCelsius, specifier: "%.1f")°")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(textColor)
        }
        .padding(.vertical, 4)
    }
}
