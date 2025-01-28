//
//  SelectedLocationView.swift
//  NooroTakeHome
//
//  Created by Jonathan on 1/27/25.
//

import SwiftUI

struct SelectedLocationView: View {
    let location: Location
    @StateObject private var viewModel = SelectedLocationViewModel()

    var body: some View {
        VStack(spacing: 16) {
            // Main weather information
            ZStack {
                VStack(spacing: 16) {
                    // Weather image
                    if let iconURL = viewModel.iconURL, let url = URL(string: iconURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 113)
                    } else {
                        ProgressView()
                            .frame(width: 123, height: 113)
                    }

                    // City name
                    HStack(spacing: 8) {
                        Text(location.name)
                            .poppins(.semiBold, size: 30)
                            .foregroundColor(.black)

                        Image(systemName: "location.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                            .foregroundColor(.black)
                    }

                    // Temperature text
                    if let temperature = viewModel.temperature {
                        ZStack(alignment: .topTrailing) {
                            Text("\(Int(temperature))")
                                .poppins(.medium, size: 65)
                                .foregroundColor(.black)
                                .frame(width: 105, height: 70, alignment: .center)
                                .padding(.bottom, 8)

                            Text("°")
                                .font(.system(size: 30))
                                .foregroundColor(.black)
                                .offset(x: 1, y: 2) // Adjust offset as needed for positioning
                        }
                    } else {
                        ProgressView()
                            .frame(width: 105, height: 70)
                            .padding(.bottom, 8)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 261)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: 261)

            // Additional Weather Info View
            if let weather = viewModel.weatherInfo {
                WeatherInfoView(humidity: weather.humidity, uvIndex: weather.uvIndex, feelsLike: weather.feelsLike)
            } else {
                ProgressView()
                    .frame(width: 274, height: 75)
            }
        }
        .onAppear {
            viewModel.fetchWeather(for: location)
        }
    }
}
